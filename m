Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255AbaLDXH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:07:58 -0500
Received: from mout.gmx.net ([212.227.17.21]:62538 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbaLDXH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:07:57 -0500
From: Peter =?windows-1252?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v8 6/8] tpm: TPM 2.0 baseline support
Date: Fri, 5 Dec 2014 00:13:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, christophe.ricard@gmail.com,
        josh.triplett@intel.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Arthur <will.c.arthur@intel.com>,
        tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com> <547E7553.2050608@linux.vnet.ibm.com>
In-Reply-To: <547E7553.2050608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201412050013.19082.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:AdWZXiDi/Au/1Qb4VMneuDKHmhhr2S7HPKn24Qt5hf1VjMYmc7Y
 DjNILPWHNhxdBeJ9e7ZSOJEw2UvZ5WZS1qxfdHhHwQjQTOiNCcJ7Mp5cNOW3AZhQGw7oZrZ
 ptGEST94VV4ugW2Y1IvqVjLqt9/D06D4PL0c3BweLEFI5dM2p9Qyoc5OO2HZCWu/vmDUK8m
 lVVMtPrB959kn+mLi6dkA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. Dezember 2014, 03:28:35 schrieb Stefan Berger:
> On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:
> > +
> > +/**
> > + * tpm2_startup() - send startup command to the TPM chip
> > + * @chip:		TPM chip to use.
> > + * @startup_type	startup type. The value is either
> > + *			TPM_SU_CLEAR or TPM_SU_STATE.
> > + *
> > + * 0 is returned when the operation is successful. If a negative number
> > is + * returned it remarks a POSIX error code. If a positive number is
> > returned + * it remarks a TPM error.
> > + */
> > +int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
> > +{
> > +	struct tpm2_cmd cmd;
> > +
> > +	cmd.header.in = tpm2_startup_header;
> > +
> > +	cmd.params.startup_in.startup_type = startup_type;
> > +	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> > +				"attempting to start the TPM");
> > +}
> 
> I suppose you need to send this command because your firmware does not
> do it ?Following TPM1.2 I guess the BIOS / UEFI should send this instead
> and sending it later would actually be wrong. Hm, I don't find from
> where you are calling this... do you need it ? Can you remove it?
> 
>     Stefan

Hi,

I think it would be good to send a TPM2_Startup if the TPM sends a 
TPM_RC_INITIALIZE (0x100) - so it becomes atleast usable.
Of course the BIOS/UEFI/Firmware should send the TPM2_Startup, but if there is 
no such thing, I would prefer Linux to do it, rather than nobody.
(analog: This was done for embedded platforms with TPM1.2).

In the current situation (v9) it is not possible to use the TPM2 on a machine 
without bios integration. :( (so I cannot test here :( )




Peter
