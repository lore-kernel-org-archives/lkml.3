Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaLNOse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:48:34 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47103 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaLNOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:48:31 -0500
Message-ID: <548DA33A.4010300@linux.vnet.ibm.com>
Date: Sun, 14 Dec 2014 09:48:26 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
CC: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: [PATCH v10 8/8] tpm: TPM 2.0 FIFO Interface
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1418413600-5400-9-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1418413600-5400-9-git-send-email-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121414-0033-0000-0000-00000303ED33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
> Detect TPM 2.0 by sending idempotent TPM 2.x command. Ordinals for
> TPM 2.0 are higher than TPM 1.x commands so this should be fail-safe.
> Using STS3 is unreliable because some chips just report 0xff and not
> what the spec says.

TPM TIS 1.2 can report either 0xff or 0x00 for sts3 since that part of 
register was not defined for this version but only for a later version. 
So, unless the TIS 1.3 for TPM 2.0 is broken, it should report a bit 
_pattern_ (not plain 0x00 or 0xff) that you could apply the suggested 
mask to and check then.

     Stefan

