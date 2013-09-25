Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3IYVag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:30:36 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34791 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab3IYVae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:30:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6+AQhpO2WvoKCSw7WokDiex_E43oi9xpuka7biPEx=7Q@mail.gmail.com>
References: <1379382464-7920-1-git-send-email-vfalico@redhat.com>
 <1379382464-7920-2-git-send-email-vfalico@redhat.com> <CAErSpo6+AQhpO2WvoKCSw7WokDiex_E43oi9xpuka7biPEx=7Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Sep 2013 15:30:14 -0600
Message-ID: <CAErSpo6jXzbgZUDbbo74vW-aSUD8MgtK5iNieFGUk=fxho102A@mail.gmail.com>
Subject: Re: [PATCH 1/3] msi: add forgotten pci_dev_put(pdev) to populate_msi_sysfs()
To: Veaceslav Falico <vfalico@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 3:08 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Also, I think it is incorrect that free_msi_irqs() does this:
>
>                 if (entry->kobj.parent) {
>                         kobject_del(&entry->kobj);
>                         kobject_put(&entry->kobj);
>                 }
>
>                 list_del(&entry->list);
>                 kfree(entry);
>
> I think the "kfree(entry)" should be in msi_kobj_release() instead.

Oh, I see you fixed this in patch 3/3.  I hadn't read that far yet :)

Did you find these problems by inspection, or is there some easy way
to trigger bad behavior?  Just wondering if this is some way I can
reproduce the problem.

Bjorn
