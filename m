Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaDPIl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:41:29 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:37876
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754792AbaDPIlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:41:23 -0400
X-WSS-ID: 0N4484S-08-4QC-02
X-M-MSG: 
Message-ID: <534E422B.3030204@amd.com>
Date: Wed, 16 Apr 2014 10:41:15 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kertesz Laszlo <laszlo.kertesz@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
CC: Alex Deucher <alexdeucher@gmail.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 15-rc1: radeon modesetting fails
References: <20140415070204.GA4806@pd.tnic> <534CFBD7.3070604@amd.com>
 <20140415120740.GA8306@nazgul.tnic>
 <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com>
 <534D677C.6080407@gmail.com> <20140415172702.GC4826@pd.tnic>
 <534D743B.8010705@gmail.com> <20140415180735.GG4826@pd.tnic>
 <534DA97E.8070505@gmail.com>
 <A3397C8B8B789E45844E7EC5DEAD89D03ECB1D65@satlexdag05.amd.com>
 <20140415224850.GA12892@pd.tnic> <534E401D.8030805@gmail.com>
In-Reply-To: <534E401D.8030805@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.99]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51874003)(189002)(199002)(51704005)(97736001)(50986999)(19580395003)(44976005)(80976001)(83322001)(36756003)(2009001)(76176999)(77096999)(99396002)(54356999)(50466002)(4396001)(76482001)(59896001)(65806001)(80022001)(20776003)(47776003)(77982001)(65956001)(23676002)(65816999)(81542001)(92566001)(85182001)(85202002)(92726001)(84676001)(79102001)(86362001)(83506001)(46102001)(64126003)(33656001)(85852003)(74502001)(31966008)(83072002)(74662001)(87936001)(81342001)(3076001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB113;H:atltwp02.amd.com;FPR:2CBE7214.BCA39E43.F6E2D1E0.87E9DDBA.201E0;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 01834E39B7
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.04.2014 10:32, schrieb Kertesz Laszlo:
> Borislav Petkov wrote:
>> On Tue, Apr 15, 2014 at 10:32:56PM +0000, Deucher, Alexander wrote:
>>> Turning off modesetting basically disables the driver.
>>
>> Well, in my case, I was using the radeon.modeset=0 variant to rule out
>> issues in x.org. And in my case x.org did start still, albeit with a
>> jacked-up resolution.
>>
>> But in Laszlo's case, x.org gets "puzzled" too.
>>
>
> Maybe your distro's xorg has some generic vga fallback method. I am 
> not aware that mine (Debian Testing) has one.
> BTW I use Debian Testing (xfce) and glamor (compiled from git) so i 
> need a specific xorg.conf.
>

Using "nomodeset" or radeon.modeset=0 tries to use the deprecated user 
mode setting, which in your case isn't even supported by the driver.

Please provide dmesg logs with drm-debug=0xe instead.

Thanks in advance,
Christian.
