Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaAGKy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:54:26 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58162 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaAGKyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:54:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140107104324.GB8991@nuc-i3427.alporthouse.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
 <1389088723-30959-2-git-send-email-artagnon@gmail.com> <20140107104324.GB8991@nuc-i3427.alporthouse.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 7 Jan 2014 16:23:44 +0530
Message-ID: <CALkWK0nuXpDGZYEcR2_2zYY=7X_Ot3FXVmZLvQiCmbZQaSM-+w@mail.gmail.com>
Subject: Re: [PATCH 1/4] drm/i915: add support for vga_switcheroo reprobe
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Chris Wilson wrote:
>> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
>> index 5c64842..336a835b 100644
>> --- a/drivers/gpu/drm/i915/i915_dma.c
>> +++ b/drivers/gpu/drm/i915/i915_dma.c
>> @@ -1265,6 +1265,12 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
>>       }
>>  }
>>
>> +static void i915_switcheroo_reprobe(struct pci_dev *pdev)
>> +{
>> +     struct drm_device *dev = pci_get_drvdata(pdev);
>> +     intel_fbdev_output_poll_changed(dev);
>> +}
>
> switcheroo should be sending a hotplug notification, which should
> trigger both this kernel listener and userspace.

If I understand correctly, switcheroo will send a hotplug notification
when LVDS is connected to the i915 device, and trigger this reprobe
function(), which in a later patch calls get-edid. Right?
