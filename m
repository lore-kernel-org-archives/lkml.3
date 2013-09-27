Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3I0QD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:03:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab3I0QD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:03:27 -0400
Date: Fri, 27 Sep 2013 18:01:25 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux.nics@intel.com,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kobject_add_internal failed for msi_irqs with -EEXIST
Message-ID: <20130927160125.GB14139@redhat.com>
References: <5245896A.70705@redhat.com>
 <CAErSpo6L-Ud08=JPM7d=RYuPO=UFvq_9hZGbne0iQnCHiFbuHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAErSpo6L-Ud08=JPM7d=RYuPO=UFvq_9hZGbne0iQnCHiFbuHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 09:58:28AM -0600, Bjorn Helgaas wrote:
>[+cc Veaceslav, linux-pci]
>
>On Fri, Sep 27, 2013 at 7:34 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>> Hi
>>
>> With recent build of 3.12-rc2 I'm getting this warning report from kernel:
>> (hw Lenovo T61, C2D, 4GB Ram)
>> (repost since linux-kernel@ rejected my gmail email....)
>
>This looks related to the MSI/kobject issues Veaceslav is working on.
>See http://lkml.kernel.org/r/1379382464-7920-2-git-send-email-vfalico@redhat.com
>and related messages.
>
>We don't have a resolution yet.  If you have
>CONFIG_DEBUG_KOBJECT_RELEASE=y, you could try turning that off.  I
>don't know if it would help, and it would only be a temporary
>workaround anyway.

I've looked at the original post -
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg510798.html
hope that's it - and it seems that it's disabling DEBUG_KOBJECT_RELEASE
won't help - the warning is about the re-registering, not about freeing it.

As a workaround I'd suggest adding some kind of delay between removing and
adding the msi - as in - rmmod e1000e; sleep 1; modprobe e1000e; - or
something like that, so that there is enough time for the /msqi_irqs/ to go
away.

>
>Bjorn
