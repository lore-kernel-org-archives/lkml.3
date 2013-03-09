Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004Ab3CIDyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:54:47 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:35911 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933431Ab3CIDyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:54:46 -0500
MIME-Version: 1.0
In-Reply-To: <87d2v9q3sk.fsf@xmission.com>
References: <20130307132819.GA31162@localhost>
	<87sj47t97s.fsf@xmission.com>
	<CADZ9YHhbvu8WYUMdDtpvkrZmLCD87fQ0Y0AcXdBaQB53=uPYYw@mail.gmail.com>
	<87d2v9q3sk.fsf@xmission.com>
Date: Sat, 9 Mar 2013 09:54:45 +0600
Message-ID: <CADZ9YHhPq7aWwmyBoEt+CsGnKfKTeZN1bCT-LtwtJxUaHGwJ=g@mail.gmail.com>
Subject: Re: [nsproxy] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000024
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 10:01 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> When a new task is created one of two things needs to happen.
> A) A reference count needs to be added to the current nsproxy.
> B) B a new nsproxy needs to be created.
>
> The way that code works today is far from a shiny example of totally
> clear code but it is not incorrect.
>
> By moving get_nsproxy down below the first return 0, you removed taking
> the reference count in the one case it is important.
>
> Arguably we should apply the patch below for clarity, and I just might
> queue it up for 3.10.
>
This one is much more cleaner. One thing regarding this patch, can we
check the namespace related flags at copy_namespace() call time at
copy_process(), also get_nsproxy()? I think this will reduce some
extra function call overhead and as you've mentioned get_nsproxy() is
needed at every process creation.

Thanks,
Rakib
