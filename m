Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaHMU1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:27:42 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:53234 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaHMU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:27:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140813123021.GX18016@ZenIV.linux.org.uk>
References: <1407929653-27228-1-git-send-email-shivnandan.k@samsung.com>
	<20140813123021.GX18016@ZenIV.linux.org.uk>
Date: Wed, 13 Aug 2014 16:27:39 -0400
Message-ID: <CACLa4pvQSA4yJTMRjh2=f8ws6pHRGp1LAFWVLDPpxsiouqGPww@mail.gmail.com>
Subject: Re: [PATCH] Security: List corruption occured during file system
 automation test
From: Eric Paris <eparis@parisplace.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: shivnandan.k@samsung.com, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        SE-Linux <selinux@tycho.nsa.gov>, cpgs@samsung.com,
        ashish.kalra@samsung.com, mohammad.a2@samsung.com,
        rajat.suri@samsung.com, shiv.jnumca08@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vidushi.koul@samsung.com, narendra.m1@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you have a backtrace?

On Wed, Aug 13, 2014 at 8:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Aug 13, 2014 at 05:04:13PM +0530, shivnandan.k@samsung.com wrote:
>> From: Shivnandan Kumar <shivnandan.k@samsung.com>
>>
>> List element was freed by  inode_free_security and then it uses rcu
>> element to point inode_free_rcu, since it inside a union so it
>> shares memory, sb_finish_set_opts now also try to free list element,
>
> How in hell does it find that element?
