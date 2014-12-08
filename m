Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaLHQSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:18:25 -0500
Received: from mout.gmx.net ([212.227.15.19]:62283 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbaLHQSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:18:23 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20141208135615.GC30303@intel.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com> <547E7553.2050608@linux.vnet.ibm.com> <201412050013.19082.PeterHuewe@gmx.de> <20141208135615.GC30303@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [tpmdd-devel] [PATCH v8 6/8] tpm: TPM 2.0 baseline support
From: peterhuewe@gmx.de
Date: Mon, 08 Dec 2014 17:18:06 +0100
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, christophe.ricard@gmail.com,
        josh.triplett@intel.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Arthur <will.c.arthur@intel.com>,
        tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Message-ID: <279e9a5e-05a9-4826-ada1-899fdcd11cea@email.android.com>
X-Provags-ID: V03:K0:cAmhlthkXTIEpZstGGvI0Cgrbc3eqBGQgVIo6FD4GrmTP3OPPpx
 agc5E5zgkAVV2S+G2TKP8D1ln3SXVIyZiOvXBW5msZ+J6Zi2tMRrBswV+RC/g9iuV+Fbi30
 XZq7Nc7UkHugAE5tTYGd/scazJOoDwnIBC5aflF7m15+jjGtvBxAmt8pt3g7RZ/jJlWksqs
 kaOdqLHWxnumTRK0MPuBQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

On 8. Dezember 2014 14:56:15 MEZ, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
>On Fri, Dec 05, 2014 at 12:13:18AM +0100, Peter Hüwe wrote:
>> Am Mittwoch, 3. Dezember 2014, 03:28:35 schrieb Stefan Berger:
>> > On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:
>> > > +
>> > > +/**
>> > > + * tpm2_startup() - send startup command to the TPM chip
>> > > + * @chip:		TPM chip to use.
>> > > + * @startup_type	startup type. The value is either
>> > > + *			TPM_SU_CLEAR or TPM_SU_STATE.
>> > > + *
>> > > + * 0 is returned when the operation is successful. If a negative
>number
>> > > is + * returned it remarks a POSIX error code. If a positive
>number is
>> > > returned + * it remarks a TPM error.
>> > > + */
>> > > +int tpm2_startup(struct tpm_chip *chip, __be16 startup_type)
>> > > +{
>> > > +	struct tpm2_cmd cmd;
>> > > +
>> > > +	cmd.header.in = tpm2_startup_header;
>> > > +
>> > > +	cmd.params.startup_in.startup_type = startup_type;
>> > > +	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
>> > > +				"attempting to start the TPM");
>> > > +}
>> > 
>> > I suppose you need to send this command because your firmware does
>not
>> > do it ?Following TPM1.2 I guess the BIOS / UEFI should send this
>instead
>> > and sending it later would actually be wrong. Hm, I don't find from
>> > where you are calling this... do you need it ? Can you remove it?
>> > 
>> >     Stefan
>> 
>> Hi,
>> 
>> I think it would be good to send a TPM2_Startup if the TPM sends a 
>> TPM_RC_INITIALIZE (0x100) - so it becomes atleast usable.
>> Of course the BIOS/UEFI/Firmware should send the TPM2_Startup, but if
>there is 
>> no such thing, I would prefer Linux to do it, rather than nobody.
>> (analog: This was done for embedded platforms with TPM1.2).
>> 
>> In the current situation (v9) it is not possible to use the TPM2 on a
>machine 
>> without bios integration. :( (so I cannot test here :( )
>
>Should the place be if sending self-test fails? I think the type should
>be TPM2_SU_CLEAR. Do you agree?
>

Yes. If the first command returns "invalid post init" or whatever it is called in tpm20 speech the driver should send the startup clear.


Not sure if we should send a startup state in the resume case (like on tpm1.2)

And also it might make sense to send a tpm_shutdown? (If we aren't already) I think even on a machine with bios integration we have to send this?


>All other issues are now fixed except this and STS3 bit issue that I 
>look for next. In my github there is tpm2-v10 branch now with fixes
>on top. I squash the fixes right after these two remaining issues are
>fixed.
>
>> Peter
>
>/Jarkko

Peter
-- 
Sent from my mobile.
