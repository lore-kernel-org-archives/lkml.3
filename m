Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaLIAse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:48:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaLIAsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:48:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141208205721.GA14895@kroah.com>
References: <201411271506.20457@pali>
	<CACVXFVPOLfDuqc0nLb-zM8vH618DLXy0xtZbUOn5_XvdxRZSDw@mail.gmail.com>
	<20141208163714.GA31169@kroah.com>
	<201412081747.30965@pali>
	<20141208205721.GA14895@kroah.com>
Date: Tue, 9 Dec 2014 08:48:28 +0800
Message-ID: <CACVXFVO+pX29UE53EDP4va0hoWQw8h0E9Ji9t3OL=e0FyERxyA@mail.gmail.com>
Subject: Re: wl1251: NVS firmware data
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        "John W. Linville" <linville@tuxdriver.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Kalle Valo <kvalo@adurom.com>,
        Sebastian Reichel <sre@ring0.de>,
        David Gnedt <david.gnedt@davizone.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 4:57 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 08, 2014 at 05:47:30PM +0100, Pali Rohár wrote:
>> On Monday 08 December 2014 17:37:14 Greg Kroah-Hartman wrote:
>> > On Mon, Dec 08, 2014 at 11:18:18PM +0800, Ming Lei wrote:
>> > > On Sat, Dec 6, 2014 at 9:02 PM, Pali Rohár
>> <pali.rohar@gmail.com> wrote:
>> > > > On Saturday 06 December 2014 13:49:54 Pavel Machek wrote:
>> > > >  /**
>> > > >
>> > > > + * request_firmware_prefer_user: - prefer usermode helper
>> > > > for loading firmware + * @firmware_p: pointer to firmware
>> > > > image
>> > > > + * @name: name of firmware file
>> > > > + * @device: device for which firmware is being loaded
>> > > > + *
>> > > > + * This function works pretty much like
>> > > > request_firmware(), but it prefer + * usermode helper. If
>> > > > usermode helper fails then it fallback to direct access.
>> > > > + * Usefull for dynamic or model specific firmware data.
>> > > > + **/
>> > > > +int request_firmware_prefer_user(const struct firmware
>> > > > **firmware_p, +                           const char
>> > > > *name, struct device *device) +{
>> > > > +       int ret;
>> > > > +       __module_get(THIS_MODULE);
>> > > > +       ret = _request_firmware(firmware_p, name, device,
>> > > > +                               FW_OPT_UEVENT |
>> > > > FW_OPT_PREFER_USER); +       module_put(THIS_MODULE);
>> > > > +       return ret;
>> > > > +}
>> > > > +EXPORT_SYMBOL_GPL(request_firmware_prefer_user);
>> > >
>> > > I'd like to introduce request_firmware_user() which only
>> > > requests firmware from user space, and this way is simpler
>> > > and more flexible since we have request_firmware_direct()
>> > > already.
>> >
>> > Why would a driver care about what program provides the
>> > firmware?  It shouldn't at all, and we want to get rid of the
>> > userspace firmware loader, not encourage drivers to use it
>> > "exclusively" at all.
>> >
>>
>> Do not remove it! Without userspace firmware loader it is
>> impossible to load dynamic firmware files.
>
> You should not be loading "dynamic" firmware files with the firmware
> interface, as that's not a "firmware" file anymore, it's a "special
> binary file that my driver needs to be created and sent into the
> kernel."

It is reasonable to put firmware somewhere instead of default
search path, maybe in network.

>
> Use your own custom usermode helper for stuff like this, not the
> firmware interface.  But use a binary sysfs file if you want, that seems
> to make sense for it...

It sounds like implementing an variant of request_firmware_user(), :-)

Thanks,
Ming Lei
