Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaFKFrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:47:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42239 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaFKFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:47:05 -0400
Date: Wed, 11 Jun 2014 08:45:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, navin patidar <navinp@cdac.in>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: usbip: stub_main.c: Cleaning up missing
 null-terminate after strncpy call
Message-ID: <20140611053612.GN5015@mwanda>
References: <1401917989-3427-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140610065735.GF5500@mwanda>
 <CAFo99gY9ROmVS56PeeAPxw6GgBnjLai3az0ABnE=1xcryDCRuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gY9ROmVS56PeeAPxw6GgBnjLai3az0ABnE=1xcryDCRuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:48:35PM +0200, Rickard Strandqvist wrote:
> Hi
> 
> True!
> Sorry  :-(
> 
> But then one would either operate strcpy outright.
> 
> Or use strlcpy then the code would be:
> 
>     /* strlcpy() handles not include \0 */
>     len = strlcpy(busid, buf + 4, BUSID_SIZE);
> 
>     /* busid needs to include \0 termination */
>     if (!(len < BUSID_SIZE))

I don't like this condition.  Just say (len >= BUSID_SIZE).  The
comments here are obvious and could be left out.

>         return -EINVAL;

I don't have strong feelings about a cleanup patch.  But I think that
cppcheck is not being very sofisticated here with the NUL termination
warning so we should not go out of our way to try to silence the
warning.

regards,
dan carpenter

