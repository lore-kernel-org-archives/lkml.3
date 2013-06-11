Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3FKSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:09:57 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:40205 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3FKSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:09:55 -0400
Message-ID: <51B767F0.6020304@cogentembedded.com>
Date: Tue, 11 Jun 2013 22:09:52 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Markos Chandras <markos.chandras@imgtec.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ethernet/3com: Drop EISA dependency from
 VORTEX
References: <1370962642-12097-1-git-send-email-markos.chandras@imgtec.com>
In-Reply-To: <1370962642-12097-1-git-send-email-markos.chandras@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-06-2013 18:57, Markos Chandras wrote:

> The Vortex driver depends on PCI with optional support for EISA.

> This fixes build problems when EISA is selected but not PCI.

> drivers/net/ethernet/3com/3c59x.c:1031:2: error: implicit declaration of
> function 'pci_iomap' [-Werror=implicit-function-declaration]
> drivers/net/ethernet/3com/3c59x.c:1044:3: error: implicit declaration of
> function 'pci_iounmap' [-Werror=implicit-function-declaration]

> Cc: David S. Miller <davem@davemloft.net>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>

    The proper way to address this is probably add empty *static inline* 
function implementations for CONFIG_PCI=n case to the header file, same 
as was done with pci_{request|release}_regions() for this same file 
several years ago...

WBR, Sergei

