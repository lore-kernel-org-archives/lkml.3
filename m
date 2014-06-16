Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbaFPWuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:50:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54638 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbaFPWui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:50:38 -0400
Message-ID: <539F7488.9040900@zytor.com>
Date: Mon, 16 Jun 2014 15:49:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Borislav Petkov <bp@alien8.de>, WANG Chao <chaowang@redhat.com>,
        Dave Young <dyoung@redhat.com>, mjg59@srcf.ucam.org, bhe@redhat.com,
        jkosina@suse.cz, greg@kroah.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall kexec_file_load
References: <20140609053538.GA2874@dhcp-17-89.nay.redhat.com> <20140609154137.GD22049@redhat.com> <20140613075011.GA4751@pd.tnic> <20140613124609.GC5871@redhat.com> <20140613153620.GG4751@pd.tnic> <20140616173823.GC4515@redhat.com> <20140616200526.GF8170@pd.tnic> <20140616205331.GA13257@redhat.com> <20140616210927.GJ8170@pd.tnic> <539F60B3.1040509@zytor.com> <20140616214313.GB1870@redhat.com>
In-Reply-To: <20140616214313.GB1870@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 02:43 PM, Vivek Goyal wrote:
>>
>> Borislav and I talked about this briefly over IRC.  A key part of that
>> is that if userspace could manipulate this system call to consume an
>> unreasonable amount of memory, we would have a problem, for example if
>> this code used vzalloc() instead of kzalloc().  However, since
>> kmalloc/kzalloc implies a relatively restrictive limit on the memory
>> allocation size anyway, well short of anything that could cause OOM
>> problems, that pretty much solves the problem.
> 
> Actually currently I am using vzalloc() for command line buffer
> allocation.
> 
> 	image->cmdline_buf = vzalloc(cmdline_len);
> 	if (!image->cmdline_buf)
> 		goto out;
> 
> Should I switch to using kzalloc() instead?
> 

Yes.  There is absolutely no valid reason to use vzalloc() for an object
that small, and if someone manipulates the header to allow for a crazily
large command line then you can trick the kernel into allocating
arbitrary amounts of memory.

	-hpa


