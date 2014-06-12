Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902AbaFLVkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:40:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51982 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFLVkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:40:08 -0400
Date: Fri, 13 Jun 2014 00:39:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, navin patidar <navinp@cdac.in>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: usbip: stub_main.c: Cleaning up missing
 null-terminate after strncpy call
Message-ID: <20140612213916.GX5500@mwanda>
References: <1401917989-3427-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140610065735.GF5500@mwanda>
 <CAFo99gY9ROmVS56PeeAPxw6GgBnjLai3az0ABnE=1xcryDCRuA@mail.gmail.com>
 <20140611053612.GN5015@mwanda>
 <CAFo99gbu5GxKSyDEfo+wpzHkjQdxqDhXF9irtCUcCNjFG2GUBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gbu5GxKSyDEfo+wpzHkjQdxqDhXF9irtCUcCNjFG2GUBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:09:20PM +0200, Rickard Strandqvist wrote:
> I agree that you should not do patches just to silence a static control program.
> 
> Concerning (len >= BUSID_SIZE) I agree! But I usually try to change as
> little as possible in the patches I do. But perhaps I should not think
> that way.

The "one thing per patch" rule is tricky for a lot of people when they
start upstream kernel programming.

1) If you are going to need to backport a patch then write the simplest
   version you can and do any cleanup in a later patch.

2) Most of these patches will not need to back ported.  The "one thing"
is about how you describe the patch.  You're allowed to make minor
closely related changes.  In this case the one thing would be, "Clean up
string handling in xxx()".  The commit message would say:

cppcheck has a false positive here.  I looked at the code and it's ok,
but a bit messy.  I have cleaned it up by doing:

	1) use strclpy() or whatever
	2) cleanup a condition
	3) remove obvious comments
	4) blah blah blah

The new code is simpler and doesn't generate a cppcheck warning.

Where checkpatch.pl get into trouble is that they say "I am doing one
thing and it is to fix everything in filename.c".  That's everything and
not "one thing".

regards,
dan carpenter

