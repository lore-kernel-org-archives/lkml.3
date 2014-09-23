Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbaIWCp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:45:26 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:52371 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaIWCpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:45:23 -0400
Date: Tue, 23 Sep 2014 02:44:51 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Michael Mullin <masmullin@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8] tpm_tis: verify interrupt during init
In-Reply-To: <20140922171338.GB28082@obsidianresearch.com>
Message-ID: <alpine.DEB.2.11.1409230232080.3995@localhost.localdomain>
References: <20140827214743.GC11183@obsidianresearch.com> <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain> <20140828165348.GE11183@obsidianresearch.com> <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain> <20140830174920.GA26218@obsidianresearch.com>
 <alpine.LNX.2.11.1408302229001.579@localhost.localdomain> <20140902172015.GD13956@obsidianresearch.com> <alpine.LNX.2.11.1409021954110.1026@localhost.localdomain> <20140908220238.GB6204@obsidianresearch.com> <alpine.LNX.2.11.1409110010290.700@localhost.localdomain>
 <20140922171338.GB28082@obsidianresearch.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Jason Gunthorpe wrote:

> On Thu, Sep 11, 2014 at 12:50:00AM +0000, Scot Doyle wrote:
>> +	if (!priv->irq_tested) {
>
> I think the sleep and check is still needed here, the IRQ delivery
> could race relative to the MMIO read of completion, a sleep is the
> only way we could attempt to synchronize them..
>
>> +		disable_interrupts(chip);
>> +		dev_err(chip->dev,
>> +			FW_BUG "TPM interrupt not working, polling instead\n");
>> +	}
>> +	priv->irq_tested = true;
>> +	return rc;
>> +}

We re-tested this v9 patch. It has the msleep(1) added just above this 
section for better formatting, as well as a devm_kzalloc check in 
tpm_tis_init. Thanks!
