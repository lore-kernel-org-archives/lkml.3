Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3CSRGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:06:55 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:63663 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756998Ab3CSRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:06:53 -0400
Message-ID: <1363712807.1390.26.camel@x61.thuisdomein>
Subject: Re: [PATCH] sparc: remove unused "config BITS"
From: Paul Bolle <pebolle@tiscali.nl>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 18:06:47 +0100
In-Reply-To: <20130319.123306.1709006318806942163.davem@davemloft.net>
References: <1363708727.1390.16.camel@x61.thuisdomein>
	 <20130319.123306.1709006318806942163.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 17:06:48.0208 (UTC) FILETIME=[24554100:01CE24C4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 12:33 -0400, David Miller wrote:
> We use this in the Makefile fragments, you cannot remove it.

>From arch/sparc/Makefile:
    ifeq ($(CONFIG_SPARC32),y)
    [...]

    [...]
    export BITS    := 32
    [...]

    else
    [...]

    [...]
    export BITS   := 64
    [...]

So $(BITS) is set depending on whether CONFIG_SPARC32 is set or not.
Using $(BITS) in sparc's Makefiles is not using CONFIG_BITS. That
doesn't count as usage of "config BITS". 


Paul Bolle

