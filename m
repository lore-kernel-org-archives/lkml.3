Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaCCH23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:28:29 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46151 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaCCH22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:28:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140301004237.GB30634@kroah.com>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
	<1392825976-17633-2-git-send-email-sudeep.holla@arm.com>
	<20140301004237.GB30634@kroah.com>
Date: Mon, 3 Mar 2014 07:28:28 +0000
X-Google-Sender-Auth: UbMugx0SOQqhTQxfvzFo1PPDyy0
Message-ID: <CAPKp9ub3aLWWaY5A98Q97YuN-Rn4U0Fg9eBmZr3OTczDUdA05A@mail.gmail.com>
Subject: Re: [PATCH RFC/RFT v3 1/9] drivers: base: add new class "cpu" to
 group cpu devices
From: Sudeep Holla <sudeep.holla@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sat, Mar 1, 2014 at 12:42 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Feb 19, 2014 at 04:06:08PM +0000, Sudeep Holla wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch creates a new class called "cpu" and assigns it to all the
>> cpu devices. This helps in grouping all the cpu devices and associated
>> child devices under the same class.
>>
>> This patch also:
>> 1. modifies the get_parent_device to return the legacy path
>>    (/sys/devices/system/cpu/..) for the cpu class devices to support
>>    existing sysfs ABI
>> 2. avoids creating link in the class directory pointing to the device as
>>    there would be per-cpu instance of these devices with the same name
>> 3. makes sure subsystem symlink continues pointing to cpu bus instead of
>>    cpu class for cpu devices
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Does the sysfs layout change at all with this patch applied?
>

No change to the existing layout, it just adds new entries, e.g. device symlink.

Before this patch:
/ # ls /sys/devices/system/cpu/cpu0/ -l
total 0
drwxr-xr-x    5 root     0                0 Jan  1 00:02 cpuidle
-rw-r--r--    1 root     0             4096 Jan  1 00:02 online
drwxr-xr-x    2 root     0                0 Jan  1 00:02 power
lrwxrwxrwx    1 root     0                0 Jan  1 00:02 subsystem ->
../../../../bus/cpu
drwxr-xr-x    2 root     0                0 Jan  1 00:02 topology
-rw-r--r--    1 root     0             4096 Jan  1 00:02 uevent

After this patch:
/sys/class/cpu # ls /sys/devices/system/cpu/cpu0 -l
total 0
drwxr-xr-x    6 root     0                0 Jan  1 00:00 cache
drwxr-xr-x    5 root     0                0 Jan  1 00:00 cpuidle
lrwxrwxrwx    1 root     0                0 Jan  1 00:00 device -> ../../cpu
-rw-r--r--    1 root     0             4096 Jan  1 00:00 online
drwxr-xr-x    2 root     0                0 Jan  1 00:00 power
lrwxrwxrwx    1 root     0                0 Jan  1 00:00 subsystem ->
../../../../bus/cpu
drwxr-xr-x    2 root     0                0 Jan  1 00:00 topology
-rw-r--r--    1 root     0             4096 Jan  1 00:00 uevent

Regards,
Sudeep
