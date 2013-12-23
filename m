Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab3LWUAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:00:09 -0500
Received: from ihemail2.lucent.com ([135.245.0.35]:63505 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3LWUAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:00:07 -0500
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Dec 2013 15:00:07 EST
Date: Mon, 23 Dec 2013 13:43:52 -0600 (CST)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: Valentina Manea <valentina.manea.m@gmail.com>
cc: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, standby24x7@gmail.com,
        alan@linux.intel.com, anthony.foiani@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, andy.grover@gmail.com
Subject: Re: [PATCH] staging: usbip: add support for viewing imported devices
In-Reply-To: <1387821655-24720-1-git-send-email-valentina.manea.m@gmail.com>
Message-ID: <Pine.GSO.4.64.1312231312580.15803@umail>
References: <1387821655-24720-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Dec 2013, Valentina Manea wrote:

> As of Matt Mooney's major refactoring in 2011, usbip port
> option was left out. Add support for this option in
> a manner similar to the old implementation.
>

Yeah, I guess most people (incluing myself) have been just happy with
just cat-ing the files in /var/run/vhci_hcd. Anyway, I guess it doesn't 
hurt to have it in the tool.

> Sample output:
>
> Imported USB devices
> ====================
> Port 00: <Port in Use> at Full Speed(12Mbps)
>       unknown vendor : unknown product (1687:6211)
>       2-1 -> usbip://192.168.122.152:3240/1-1 (remote devid 00010002 (bus/dev 001/002))
>

I don't find devid very useful when you are already printing bus and 
device number; devid is just a different format for the same thing. Just 
bus number and device number should suffice.

>
> [SNIP]
>
>
> +int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev)
> +{
>
> [SNIP]
>
> +
> +	ret = read_record(idev->port, host, serv, remote_busid);
> +	if (ret) {
> +		err("read_record");
> +		return -1;
> +	}
> +

If the caller is looping over the ports and dumping one port fails because 
some bozo has rm-ed the record file, is it the right thing to bail out of 
completely? You may want to consider continuing with the loop and still 
show what can be shown (and mark unshowable ports as such).

In that sense, you probably don't want to return an error here.

>
> +	printf("Port %02d: <%s> at %s\n", idev->port,
> +	       usbip_status_string(idev->status),
> +	       usbip_speed_string(idev->udev.speed));
>
> [SNIP]
>
> +int usbip_port_show(int argc, char *argv[])
> +{
> +	(void) argc;
> +	(void) argv;
> +

This is an ugly way to suppress the warning. Consider using 
__attribute__((unused)) instead.


-- Ilija

