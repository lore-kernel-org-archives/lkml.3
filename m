Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbaG3WvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:51:18 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:58693 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaG3WvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:51:15 -0400
Date: Wed, 30 Jul 2014 15:51:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Hellwig <hch@infradead.org>
cc: Fengguang Wu <fengguang.wu@intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [delayed_fput] BUG: unable to handle kernel paging request at
 ffff8800122a0ad0
In-Reply-To: <20140730111521.GB759@infradead.org>
Message-ID: <alpine.DEB.2.02.1407301550140.26018@chino.kir.corp.google.com>
References: <20140730035541.GD16537@localhost> <20140730111521.GB759@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014, Christoph Hellwig wrote:

> On Wed, Jul 30, 2014 at 11:55:41AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> How does this manage to trip over a 2 year old commit now?
> 

I think there's something weird going on with the testing of CONFIG_SLOB, 
same as http://permalink.gmane.org/gmane.linux.kernel/1759314 that 
identified a harmless commit that only initializes a field of
struct mm_struct and then ended up exploded in slob freeing.
