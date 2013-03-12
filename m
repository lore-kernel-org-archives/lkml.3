Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab3CLS0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:26:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:57871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab3CLS0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:26:21 -0400
Message-ID: <513F7364.50408@infradead.org>
Date: Tue, 12 Mar 2013 11:26:44 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: IPC Namespace Depends and SYSVIPC
References: <20130308120308.4f1ad93c4aed631185494201@lavabit.com>
In-Reply-To: <20130308120308.4f1ad93c4aed631185494201@lavabit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/13 12:03, rh wrote:
> Not sure what I'm looking at but here's what I see when I do a sym
> search in nconfig.  Note: Namespace seems to depend in SYSVIPC or
> not.

from init/Kconfig:

config IPC_NS
	bool "IPC namespace"
	depends on (SYSVIPC || POSIX_MQUEUE)
	default y

so as long as POSIX_MQUEUE is enabled, the value of SYSVIPC does not matter.

or did I misunderstand your statement/confusion/question?


> ______________________
> With SYSVIPC enabled:
> 
> Symbol: IPC_NS [=y]
> Type  : boolean
> Prompt: IPC namespace
> Defined at init/Kconfig:794
> Depends on: NAMESPACES [=y] && (SYSVIPC [=y] || POSIX_MQUEUE [=y])
> Location:
> -> General setup
> -> Namespaces support (NAMESPACES [=y])
> 
> _______________________
> With SYSVIPC disabled:
> 
> 
> Symbol: IPC_NS [=y]
> Type  : boolean
> Prompt: IPC namespace
> Defined at init/Kconfig:794
> Depends on: NAMESPACES [=y] && (SYSVIPC [=n] || POSIX_MQUEUE [=y])
> Location:
> -> General setup
> -> Namespaces support (NAMESPACES [=y])


-- 
~Randy
