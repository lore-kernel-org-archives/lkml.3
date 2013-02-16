Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3BPWJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 17:09:58 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3116 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab3BPWJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 17:09:57 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Subject: Re: [PATCH 2/2] tg3: Use different macros for pci_chip_rev_id
 accesses
From: "Michael Chan" <mchan@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "Matt Carlson" <mcarlson@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1d3ed7a644e8de210614f51375e8e913da2f5cb3.1361049158.git.joe@perches.com>
References: <dea1c655b2c1380821aae6cd8438ad742ddf6e12.1361049158.git.joe@perches.com>
 <1d3ed7a644e8de210614f51375e8e913da2f5cb3.1361049158.git.joe@perches.com>
Date: Sat, 16 Feb 2013 14:09:45 -0800
Message-ID: <1361052585.2240.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7D3EDD6A3QG3926509-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-16 at 13:20 -0800, Joe Perches wrote:
> Upper case macros for various chip attributes are slightly
> difficult to read and are a bit out of characterto the other
> tg3_<foo> attribute functions.
> 
> Convert:
> 
> GET_ASIC_REV(tp->pci_chip_rev_id)       -> tg3_asic_rev(tp)
> GET_CHIP_REV(tp->pci_chip_rev_id)       -> tg3_chip_rev(tp)
> 
> Remove:
> GET_METAL_REV(tp->pci_chip_rev_id)      -> tg3_metal_rev(tp) (unused)
> 
> Add:
> tg3_chip_rev_id(tp) for tp->pci_chip_rev_id so access styles
> are similar to tg3_asic_rev and tg3_chip_rev.
> 
> These macros are not converted to static inline functions
> because gcc (tested with 4.7.2) is currently unable to
> optimize the object code it produces the same way and code
> is otherwise larger.
> 
> Signed-off-by: Joe Perches <joe@perches.com> 

Acked-by: Michael Chan <mchan@broadcom.com>


