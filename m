Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaIMELj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 00:11:39 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61638 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaIMELh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 00:11:37 -0400
Message-ID: <5413C3F4.2070009@gmail.com>
Date: Sat, 13 Sep 2014 13:11:32 +0900
From: Seunghun Lee <waydi1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: remove redundant sanity check in do_mount
References: <1410537212-3153-1-git-send-email-waydi1@gmail.com> <20140912162834.GE7996@ZenIV.linux.org.uk>
In-Reply-To: <20140912162834.GE7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/13/2014 01:28 AM, Al Viro wrote:
> On Sat, Sep 13, 2014 at 12:53:32AM +0900, Seunghun Lee wrote:
>> In sys_mount, getname() checks dir_name.
>> So do_mount needn't check dir_name again.
> ... and simple grep shows four more call sites.  At the very least, the
> commit message needs to cover those as well, *if* the check is, indeed,
> redundant.  From the look through those guys it looks like it is, but...
> I wonder if it would make more sense to pass char __user * instead of
> char * here.  And do getname() inside do_mount().  As it is, we do
> getname() in all callers *and* never look into the result of said getname()
> until passing it to do_mount().  So how about just passing userland pointer
> all the way down to do_mount() (grep for callers and watch out for ones
> in arch/alpha/kernel/osf_sys.c) and doing getname() in do_mount() itself?
Ok, I will rework the patch.

Thanks.
