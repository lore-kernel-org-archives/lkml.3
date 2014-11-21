Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaKUL6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:58:42 -0500
Received: from mout.perfora.net ([74.208.4.197]:50954 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbaKUL6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:58:40 -0500
Message-ID: <1416571072.2744.4.camel@localhost.localdomain>
Subject: Re: [PATCH] ARM: tegra: colibri t30: fix on-module ethernet
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org
Cc: thierry.reding@gmail.com, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch
Date: Fri, 21 Nov 2014 12:57:52 +0100
In-Reply-To: <b1cdc96ce8bb15059d7eea282f6586a826bee124.1416566157.git.marcel@ziswiler.com>
References: <b1cdc96ce8bb15059d7eea282f6586a826bee124.1416566157.git.marcel@ziswiler.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:YHQbMCkbh/SIiFWV/vVXafpv+4hha5wjUBI4lxfxuEA
 r3EN3kIPRYvT5qem0A1dQE9Rvk7LIuK2xmht8hH/+4w2VRTNLN
 VyU2admSez9+NTKsxEWF8t+M76nz2nxg++/IiVJ48JMOx5zv9m
 BnMIF+nRzb752TLI3zAzl7rGlB+Kbaei0FFGAw+bU4NwOPGAtN
 TYCqM0URzm+1LrvTaQ9LTN0XW1O3e9vhj6uWS/DTR/ngLdSuG3
 pSYutU6ho8M+lgHN9vllReaEF4YwpMWNnPfAXUlGzeIPpgUmxl
 mrMtXnlfysvOrSSRJBzfAb95tKR17psE3kHeXDudiyTXTY7EF2
 pLlWTKycXD6ar1xWDctTPf08KgaTtMi8y2DTmM7l3
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 11:41 +0100, Marcel Ziswiler wrote:
> Looks like Ethernet only ever worked if U-Boot properly brought it up
> as both the reset as well as the VBUS lines were not actively handled
> in-kernel.
> This patch fixes this by just pulling up the reset GPIO

Doing automatic power-cycle tests revealed that this is still not enough
and a proper reset-cycle might be required. However I don't know as of
yet how one can easily do that in mainline with a USB device otherwise
not mentioned anywhere in the device tree. Any ideas?

> and properly
> enabling VBUS via a GPIO enabled fixed regulator VBUS supply.
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>

