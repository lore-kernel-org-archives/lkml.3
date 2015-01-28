Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbbA2BYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:24:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbbA2BYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:24:04 -0500
Message-ID: <54C8FFBA.5040000@suse.cz>
Date: Wed, 28 Jan 2015 16:26:50 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kconfig: warn if an unknown symbol is selected
References: <1412100583.21730.31.camel@x220>	 <1415014691.20372.49.camel@x220> <1422438897.5666.23.camel@x220>
In-Reply-To: <1422438897.5666.23.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-28 10:54, Paul Bolle wrote:
> Now that we've been told Yann has disappeared, would you consider taking
> this patch into one of your trees? It would be nice to have people
> actually use it for a while.
> 
> Or should we first clean up (most of) the warnings it generates? There

It seems your fixes have been accepted in the meantime, but there is one
new:
*** Default configuration is based on 'x86_64_defconfig'
drivers/misc/cxl/Kconfig:8:warning: 'CXL_BASE' selects unknown symbol
'PPC_COPRO_BASE'

PPC_COPRO_BASE is not known on x86, but at the same time, there is no
way for CXL_BASE to be selected on x86:

config CXL_BASE
	bool
	default n
	select PPC_COPRO_BASE

config CXL
	tristate "Support for IBM Coherent Accelerators (CXL)"
	depends on PPC_POWERNV && PCI_MSI
	select CXL_BASE
	default m

Shouldn't we only warn about a select when it is triggered? An
allyesconfig would still report all bogus selects for given architecture.

Michal
