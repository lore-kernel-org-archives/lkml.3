Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3FGBRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:17:10 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35891 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3FGBRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:17:07 -0400
Message-ID: <51B134A6.1020808@gmail.com>
Date: Fri, 07 Jun 2013 09:17:26 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Boszormenyi Zoltan <zboszor@pr.hu>
CC: dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Steve Tilden <stilden@sicom.com>
Subject: Re: New prototype computer problem with S3 suspend
References: <51B0D0DE.30902@pr.hu>
In-Reply-To: <51B0D0DE.30902@pr.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 02:11 AM, Boszormenyi Zoltan wrote:
> Hi,
> 
> we are working on an Intel Atom-based embedded PC and I have to
> make suspend-to-RAM work but I can't seem to succeed.
> 
> The symptom is that quite often, the machine resumes immediately
> after pm-suspend. Sometimes more than 20 times out of 50 attempts.

Can you please file a bug about this?
https://bugzilla.kernel.org

> 
> I have tried 3.7.10, 3.9.4, 3.10-rc[234] and the linux-next branch from the
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git repository.
> The attached dmesg is from today's linux-pm/linux-next plus the
> latest drm-fixes patchset posted by Dave Airlie.
> 
> I have tried disabling wakeup devices via /proc/acpi/wakeup and via sysfs files.
> (/sys/devices/.../wakeup)

>From the dmesg, the following three devices are still armed with wakeup
capability and might be the cause:

i8042 kbd 00:03: System wakeup enabled by ACPI
PM: suspend of devices complete after 578.883 msecs
PM: late suspend of devices complete after 0.279 msecs
pcieport 0000:00:1c.1: System wakeup enabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
PM: noirq suspend of devices complete after 31.946 msecs

Anyway, please file a bug there, thanks.

-Aaron
