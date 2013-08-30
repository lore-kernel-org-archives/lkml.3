Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3H3Uqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:46:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54871 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab3H3Uqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:46:43 -0400
Message-ID: <522104A6.5000700@zytor.com>
Date: Fri, 30 Aug 2013 13:46:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH V2 10/10] Add option to automatically enforce module signatures
 when in Secure Boot mode
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com> <1376933171-9854-11-git-send-email-matthew.garrett@nebula.com> <20130829183713.GT20828@hansolo.jdub.homelinux.org>
In-Reply-To: <20130829183713.GT20828@hansolo.jdub.homelinux.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 11:37 AM, Josh Boyer wrote:
>>  	setup_efi_pci(boot_params);
>> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
>> index c15ddaf..d35da96 100644
>> --- a/arch/x86/include/uapi/asm/bootparam.h
>> +++ b/arch/x86/include/uapi/asm/bootparam.h
>> @@ -131,7 +131,8 @@ struct boot_params {
>>  	__u8  eddbuf_entries;				/* 0x1e9 */
>>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
>>  	__u8  kbd_status;				/* 0x1eb */
>> -	__u8  _pad5[3];					/* 0x1ec */
>> +	__u8  secure_boot;				/* 0x1ec */
>> +	__u8  _pad5[2];					/* 0x1ec */
>>  	/*
>>  	 * The sentinel is set to a nonzero value (0xff) in header.S.
>>  	 *
> 
> You need to include the following chunk of code with this, otherwise the
> secure_boot variable gets cleared.
> 

Not really.

There are three cases:

1. Boot stub only.  Here we do the right thing with the bootparams.
2. Boot loader bypasses the boot stub completely.  Here we MUST NOT do
   what you suggest above.
3. Boot stub with a boot_params structure passed in.  Here we should
   run sanitize_boot_params() (an inline for a reason) in the boot
   stub, before we set the secure_boot field.  Once that is done, we
   again don't need that modification.

	-hpa

