Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3JaNR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:17:28 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57716 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3JaNR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <8761sexu2l.fsf@xmission.com>
References: <8761sexu2l.fsf@xmission.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 31 Oct 2013 07:17:04 -0600
Message-ID: <CAErSpo7BH3k7nmECwRzgRFzhQLyiGhSkxbpwW8dtn+yk7MnrXg@mail.gmail.com>
Subject: Re: WTF: driver-core-next contains recursive directory removal!
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Wed, Oct 30, 2013 at 4:38 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Greg what is  going on?  I just looked and Tejuns ill-conceived recursive
> directory deletion code has been merged into your driver-core-next tree.
>
> That code is semantically broken.  I reviewed it and I gave the reasons
> why it was wrong.  You came up to me and mentioned at LPC that you
> agreed with my reasons.  And yet I just looked in driver-core-next and
> there the code is in all of it's broken glory.
>
> Please pull out that crap it has no business ever going into a stable
> kernel.
>
> The short version is unless someone has drastically changed pci hotplug
> since last time I looked the code is dramatically wrong as pci hotplug
> removes directories in the wrong order remove the parent first.

Can you please elaborate on exactly where PCI hotplug removes things
in the wrong order?  We are struggling with many issues in PCI
removal, and if you can help us fix them by pointing out an issue,
that would be great.

I did work through removal of a small tree [1], and it appeared to me
that we removed sysfs things in bottom-up order, but maybe I missed
something or you're talking about a different situation.

Thanks,
  Bjorn

[1] http://lkml.kernel.org/r/CAErSpo6g5vR0NMs18YZBz+6RGZd0zNeDu_=1Pk4c5a+OqHfS1g@mail.gmail.com

> So now we have sysfs code that is remove directories multiple times, and
> we just finished the conversation about sysfs_assoc_lock where Tejun was
> just explaining how multiple removal of kobjects is not safe.
>
> This sysfs semantic change is an unmaintainable disaster.
>
> Linus if you would be so kind as to not merge this disaster when the
> merge window opens I would very much appreciate it.
>
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
