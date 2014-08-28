Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaH1Aia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 20:38:30 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:55912 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaH1Ai3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 20:38:29 -0400
Date: Thu, 28 Aug 2014 00:35:16 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] tpm_tis: verify interrupt during init
In-Reply-To: <20140827214743.GC11183@obsidianresearch.com>
Message-ID: <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain>
References: <alpine.LNX.2.11.1408220043560.1360@localhost.localdomain> <20140822160626.GA8477@obsidianresearch.com> <alpine.LNX.2.11.1408221924070.1046@localhost.localdomain> <20140822203241.GB1733@obsidianresearch.com> <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
 <20140825182414.GB1298@obsidianresearch.com> <alpine.LNX.2.11.1408270410190.701@localhost.localdomain> <20140827173142.GA11183@obsidianresearch.com> <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain> <20140827214743.GC11183@obsidianresearch.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 Aug 2014, Jason Gunthorpe wrote:

> On Wed, Aug 27, 2014 at 09:32:10PM +0000, Scot Doyle wrote:
>>>> -    if (tpm_do_selftest(chip)) {
>>>> -            dev_err(dev, "TPM self test failed\n");
>>>> -            rc = -ENODEV;
>>>> -            goto out_err;
>>>> -    }
>>>
>>> Move gettimeout too
>>
>> Can it be moved? It sends startup(clear) if the TPM isn't yet operational.
>
> To move it means we have to understand why you are getting timeouts:
>
> [   33.247720] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
> [   33.247731] tpm_tis 00:08: [Hardware Error]: TPM command timed out during continue self test
>
> I had thought based on your other patch that these should not happen
> since the raw register is polled after the timer expires?

It is polled after the timer expires in tpm_tis_send_data, but not in 
tpm_tis_send, and the return value is used in tpm_tis_send...

> What is going on here? Do you still have that other patch applied?

...so with the other patch applied too, the output is:
[    1.464217] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
[    3.570836] tpm_tis 00:08: tpm_transmit: tpm_send: error -62
[    3.660885] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead

Much better! Any thoughts before I proceed?
