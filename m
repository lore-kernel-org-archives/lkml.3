Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3BMSiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:38:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43549 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab3BMSiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:38:54 -0500
Date: Wed, 13 Feb 2013 19:38:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Scan Subscription <scan-subscription@coverity.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: New Defect(s) reported by Coverity Scan
Message-ID: <20130213183842.GC26948@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Scan Subscription <scan-subscription@coverity.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>
References: <C0A4ACBB26D853488EA0C68388B70268172CCF11@BLUPRD0512MB628.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C0A4ACBB26D853488EA0C68388B70268172CCF11@BLUPRD0512MB628.namprd05.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 05:40:11PM +0000, Scan Subscription wrote:
> Hi,
> 
> Please find the latest report on new defect(s) that have been introduced to the Linux Kernel found with Coverity SCAN. 
> 
> 
> Defect(s) Reported-by: Coverity Scan:
> ___________________________________________________________________________
> ** CID 971353: Resource leak (RESOURCE_LEAK)
> /arch/x86/boot/tools/build.c: 259
> http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=971353
> 
> 
> ###########################################################################
> Defect Details:
> ___________________________________________________________________________
> CID 971353: Resource leak (RESOURCE_LEAK)
> http://scan5.coverity.com:8080/sourcebrowser.htm?projectId=10063#mergedDefectId=971353
> 
> /arch/x86/boot/tools/build.c: 240 ( alloc_fn)
> 
>    234 static void parse_zoffset(char *fname)
>    235 {
>    236        FILE *file;
>    237    	char *p;
>    238    	int c;
>    239    
> >>> Storage is returned from allocation function "fopen(char const * restrict, char const * restrict)".
> >>> Assigning: "file" = storage returned from "fopen(fname, "r")".
>    240    	file = fopen(fname, "r");
>    241    	if (!file)
>    242    		die("Unable to open `%s': %m", fname);
> >>> Resource "file" is not freed or pointed-to in function "fread(void * restrict, size_t, size_t, FILE * restrict)".
>    243    	c = fread(buf, 1, sizeof(buf) - 1, file);
> >>> Resource "file" is not freed or pointed-to in function "ferror(FILE *)".
>    244    	if (ferror(file))
>    245    		die("read-error on `zoffset.h'");
>    246    	buf[c] = 0;
>    247    
>   
> 
> /arch/x86/boot/tools/build.c: 259 ( leaked_storage)
>    256    		while (p && (*p == '\r' || *p == '\n'))
>    257    			p++;
>    258    	}
> >>> CID 971353: Resource leak (RESOURCE_LEAK) Variable "file" going out 
> >>> of scope leaks the storage it points to.

Well, we do

	fclose(file)

a couple of lines later in the same function.

The only problem I can see is that we don't fclose the file when ferror
returns non-NULL but that shouldn't matter because we die() then and all
resources are automatically freed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
