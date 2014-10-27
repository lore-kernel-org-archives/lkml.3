Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaJ0C0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:26:15 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:37354 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbaJ0C0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:26:14 -0400
Message-ID: <1414376761.12733.13.camel@linux-t7sj.site>
Subject: Re: [LKP] [futex] 76835b0ebf8: -12.1% will-it-scale.per_process_ops
From: Davidlohr Bueso <dave@stgolabs.net>
To: kernel test robot <fengguang.wu@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Date: Sun, 26 Oct 2014 19:26:01 -0700
In-Reply-To: <20141027021822.GH27038@yliu-dev.sh.intel.com>
References: <20141027021822.GH27038@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 10:18 +0800, kernel test robot wrote:
> FYI, we noticed the below changes on
> 
> commit 76835b0ebf8a7fe85beb03c75121419a7dec52f0 ("futex: Ensure get_futex_key_refs() always implies a barrier")

fwiw I was also able to reproduce similar results, with the hashing
costing (unsurprisingly) around an extra ~10% with the new barrier, not
much we can do about that. In any case these are pretty low level
measurements so shouldn't impact too much. Additionally, any user that
cares about performance will try to avoid incurring futex calls into
kernel space.

