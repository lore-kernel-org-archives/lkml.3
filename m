Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbbA2Ng5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:36:57 -0500
Received: from david.siemens.de ([192.35.17.14]:44155 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbbA2Ngz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:36:55 -0500
Message-ID: <54CA3736.4090600@siemens.com>
Date: Thu, 29 Jan 2015 14:35:50 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v11 23/28] scripts/gdb: Ignore byte-compiled python files
References: <cover.1422514006.git.jan.kiszka@siemens.com> <fd0c2a6ad6e1d021ce85798f9cd89d9e3381288e.1422514006.git.jan.kiszka@siemens.com> <54CA325F.9070906@suse.cz>
In-Reply-To: <54CA325F.9070906@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-29 14:15, Michal Marek wrote:
> On 2015-01-29 07:46, Jan Kiszka wrote:
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1179,7 +1179,8 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
>>  		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
>>  		  signing_key.priv signing_key.x509 x509.genkey		\
>>  		  extra_certificates signing_key.x509.keyid		\
>> -		  signing_key.x509.signer vmlinux-gdb.py
>> +		  signing_key.x509.signer vmlinux-gdb.py		\
>> +		  scripts/gdb/linux/*.py[co]
> 
> In 01/28, you already have
> 
> +clean-files := *.pyc $(if $(KBUILD_SRC),*.py)
> 
> Maybe just add *.pyo there and you don't need to add it to the toplevel
> Makefile.

Based on a quick test, you seem right. Daniel, anything we miss?

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
