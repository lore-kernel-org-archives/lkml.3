Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab3BMSzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:55:14 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:48503
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932297Ab3BMSzK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:55:10 -0500
X-Forefront-Antispam-Report: CIP:132.245.1.149;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0512HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dh1954cbhz32i2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1155h)
From: Scan Subscription <scan-subscription@coverity.com>
To: Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: New Defect(s) reported by Coverity Scan
Thread-Topic: New Defect(s) reported by Coverity Scan
Thread-Index: AQHOChlncbuOF72N0UW3qeR3/Zy8NZh4IOBq
Date: Wed, 13 Feb 2013 18:55:03 +0000
Message-ID: <C0A4ACBB26D853488EA0C68388B70268172CD159@BLUPRD0512MB628.namprd05.prod.outlook.com>
References: <C0A4ACBB26D853488EA0C68388B70268172CCF11@BLUPRD0512MB628.namprd05.prod.outlook.com>,<20130213183842.GC26948@pd.tnic>
In-Reply-To: <20130213183842.GC26948@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.125.71.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: coverity.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris

There is no fclose(file) call in parse_zoffset() function
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob_plain;f=arch/x86/boot/tools/build.c;hb=HEAD 

There is only one flcose call in this file and it is in the main() function
Let us know if I am missing anything

Thanks
Dakshesh Vyas
Coverity SCAN-ADMIN
scan-admin at coverity.com
http://scan.coverity.com

________________________________________
From: Borislav Petkov [bp@alien8.de]
Sent: Wednesday, February 13, 2013 10:38 AM
To: Scan Subscription
Cc: linux-kernel@vger.kernel.org; hpa@zytor.com
Subject: Re: New Defect(s) reported by Coverity Scan

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
>    237        char *p;
>    238        int c;
>    239
> >>> Storage is returned from allocation function "fopen(char const * restrict, char const * restrict)".
> >>> Assigning: "file" = storage returned from "fopen(fname, "r")".
>    240        file = fopen(fname, "r");
>    241        if (!file)
>    242                die("Unable to open `%s': %m", fname);
> >>> Resource "file" is not freed or pointed-to in function "fread(void * restrict, size_t, size_t, FILE * restrict)".
>    243        c = fread(buf, 1, sizeof(buf) - 1, file);
> >>> Resource "file" is not freed or pointed-to in function "ferror(FILE *)".
>    244        if (ferror(file))
>    245                die("read-error on `zoffset.h'");
>    246        buf[c] = 0;
>    247
>
>
> /arch/x86/boot/tools/build.c: 259 ( leaked_storage)
>    256                while (p && (*p == '\r' || *p == '\n'))
>    257                        p++;
>    258        }
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


