Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3C3BCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 21:02:48 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:52491 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab3C3BCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 21:02:46 -0400
MIME-Version: 1.0
In-Reply-To: <2045510.EK2WTuFZxV@vostro.rjw.lan>
References: <1364444938-19801-1-git-send-email-yinghai@kernel.org>
	<2045510.EK2WTuFZxV@vostro.rjw.lan>
Date: Fri, 29 Mar 2013 18:02:45 -0700
X-Google-Sender-Auth: x2URzVGkxFPTQANJDhusQSyQ6Sc
Message-ID: <CAE9FiQWM=egh3OPcWMD+bJv2FtSsGopk_Pq0JUpQCy+pvja-6A@mail.gmail.com>
Subject: Re: [PATCH] PCI, ACPI: Don't query OSC support with all possible controls
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Len Brown <len.brown@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 5:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> -             /* Run _OSC query for all possible controls. */
>> -             capbuf[OSC_CONTROL_TYPE] = OSC_PCI_CONTROL_MASKS;
>> +             /* Run _OSC query only with existing controls. */
>> +             capbuf[OSC_CONTROL_TYPE] = root->osc_control_set;
>
> I suppose we can do that, but then why this should be root->osc_control_set and
> not just 0?

in case query support and set control are called in mixed sequence.

And ACPI spec says if control set and can not be revoked.

also when it control is passed, it is always OR with root->os_control_set.
    capbuf[OSC_CONTROL_TYPE] = *control | root->osc_control_set;


Yinghai
