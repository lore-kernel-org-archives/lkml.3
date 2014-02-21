Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbaBUOwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:52:22 -0500
Received: from nm49.bullet.mail.ne1.yahoo.com ([98.138.120.56]:22488 "HELO
	nm49.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754396AbaBUOwR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:52:17 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 475411.63864.bm@omp1007.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rMpibQ/TuCYj1rDTJMNMDtTrpi1wpKqv/Y1LUw7r0Eca1BGo+fWib5jBgtfuMBt/GlkdekkN1iftVIe0Rnr/0dY21zUI9t4GvvXCGSgZteWo5CLKGab/gjGiY8TO0NV+aGB3hZ8T6xHpO812XHxCiuAH5lKxB0IsTu4vffdBjss=;
X-YMail-OSG: Ldh8ttMVM1nWrvVx67Cvv_85L7m7G_RZLeIT2FNulQQbRI0
 fMOMQRnHDIYIsqYYHc60BMZjQUX2vufrYGSaC6LCdiUFrlGR5rpOYQx6h.mj
 fkb3cwxtuyNSryhhESMbPLyx9smnv1jh6mFrcG428Qyt_AM6PKu55oLSYaoa
 ysJpDq1_dVirye_UFgV3sXJFZhaS1jUoQ.qcf6df1u4ZQgSSxgIBNcy.4.Ie
 c_HUQRUUYa68ZWxEyooxHr.ryLaiLluRcuMK_SLFyRidsgF1vDsmF6IrRUAp
 ESJtRUuo1Xr8R6fC0QXEqAd__2MBAbvDs8vabvSBvcQua8TNJngiFdAn_lBW
 ASQzWfeJS3G8ngI3qD3rexB6TsC1cKqlBXX_L_2yGUs5pfJ0t_hd0EdP0sxE
 ke9sIiOKIzmR_wKJaHRYRthJGOGqUWkAsUTts3SjJ9jPcV.j1SylFwg7iv98
 yc5CdFaqxgIhLlE3oHnIQjADMo_OFFVWX31Uho8SjjOz.k2QtFaZsrDwjG87
 sMY72DMZT0BEsHrDAMt.m8p7cqnaKodUk4jooALDAclsrBIycenkGRIxW_X_
 qkosOEPQ145l8qbZzmQLE8HBMNDs-
X-Rocket-MIMEInfo: 002.001,T24gRnJpZGF5LCAyMSBGZWJydWFyeSAyMDE0LCA5OjQ3LCBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUByZWRoYXQuY29tPiB3cm90ZToKCj4gVGhpcyBpcyBsaWtlbHkgY2F1c2VkIGJ5IHRoZSBjYW1lcmEgYmVpbmcgcGx1Z2dlZCBpbnRvIGEgdXNiLWJ1cyB3aGljaCBhbHJlYWR5IGlzIHVzZWQKPiBieSBvdGhlciByZXNlcnZlZC1iYW5kd2lkdGggZGV2aWNlcyBzdWNoIGFzIG1pY2UsIGtleWJvYXJkLCB1c2Igc291bmRjYXJkcywgZXRjLgoKPiBJZiBwb3NzaWJsZSBVU0ItMyBwb3J0cyBhcmUgcHJlZmVycmUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1392924626.38711.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5307208B.8030908@redhat.com>
Message-ID: <1392994175.4964.YahooMailNeo@web120304.mail.ne1.yahoo.com>
Date: Fri, 21 Feb 2014 06:49:35 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: PWC webcam and setpwc tool no longer working with 3.12.11 kernel
To: Hans de Goede <hdegoede@redhat.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5307208B.8030908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 February 2014, 9:47, Hans de Goede <hdegoede@redhat.com> wrote:

> This is likely caused by the camera being plugged into a usb-bus which already is used
> by other reserved-bandwidth devices such as mice, keyboard, usb soundcards, etc.

> If possible USB-3 ports are preferred over USB-2 ports or connecting through an USB-2
> hub. USB-2's USB-1 emulation has some issues, which means we cannot use full USB-1 bandwidth
> there.

Hi,

Yes, it turns out that every device plugged into one of the USB2 ports on the back of this PC ends up on the same USB2 hub. Moving the PWC device to one of the USB3 ports instead allows it to work, although it seems like a shocking waste of a USB3 port - this being an old USB1 webcam!

And v4l2-ctl seem to recognise it as well:

$ v4l2-ctl --info
Driver Info (not using libv4l2):
    Driver name   : pwc
    Card type     : Logitech QuickCam Zoom
    Bus info      : usb-0000:05:00.0-2
    Driver version: 3.12.11
    Capabilities  : 0x85000001
        Video Capture
        Read/Write
        Streaming
        Device Capabilities
    Device Caps   : 0x05000001
        Video Capture
        Read/Write
        Streaming

Cheers,
Chris

