Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbaGCPGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:06:04 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63005 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbaGCPGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:06:02 -0400
MIME-Version: 1.0
In-Reply-To: <53B5514E.5050504@denx.de>
References: <CAL8zT=gW-OCeeOhKZzqgVSxDE5gsWt2O9nQ9mt7diDZQvvRO=w@mail.gmail.com>
 <53B5514E.5050504@denx.de>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 3 Jul 2014 17:05:46 +0200
Message-ID: <CAL8zT=i5A8hUdovht9HQGmv=xnHePcDkfw1fm-a62-FHedHd4A@mail.gmail.com>
Subject: Re: Lattice ECP3 FPGA with i.MX6
To: Stefan Roese <sr@denx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No. This driver was implemented and tested in a MPC5200 system. Most likely
> I missed some endian issues as you already noticed. I suggest you start with
> looking at this line:
>
>         jedec_id = *(u32 *)&rxbuf[4];
>
> And add some endian functions here, e.g. be32_to_cpu(). This might help with
> the detection. But other endian related issues might still be present in
> other parts of the driver as well.

Replacing this line with the following works better :
jedec_id = be32_to_cpu(*(u32 *)&rxbuf[4]);

At least, on detecting the FPGA...
I will send a patch, but there is only three places where there is a
be32_to_cpu() to add.
