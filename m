Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3FMHXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:23:38 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36881 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3FMHXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:23:36 -0400
Date: Thu, 13 Jun 2013 10:23:27 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130613072327.GA12951@x220>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
	gustavo@padovan.org, linux-bluetooth@vger.kernel.org
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
 <20130610133834.GA4058@amd.pavel.ucw.cz>
 <20130610160723.GA18282@x220.P-661HNU-F1>
 <20130610193746.GA30801@amd.pavel.ucw.cz>
 <20130611072245.GA12463@x220>
 <20130611102025.GA5580@x220>
 <20130612112326.GA4237@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612112326.GA4237@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, Jun 12, 2013, Pavel Machek wrote:
> < HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> > HCI Event: Command Complete (0x0e) plen 68
>     Read Local Supported Commands (0x04|0x0002) ncmd 1
>     status 0x00
>     Commands: ffffffffffff1ffffffffffff30fffff3f

As I suspected, even though the Delete Stored Link Key command is
mandatory from Bluetooth version 1.1 onwards (this controller supports
2.0) this controller doesn't have it mentioned in its supported commands
response (counting from 0 it should be bit 7 of octet 6). Therefore, it
might be possible to just move sending of this problematic command to
after receiving the supported commands response and making it
conditional to having its respective bit set in the mask. I'll be
sending another patch proposal soon.

Johan
