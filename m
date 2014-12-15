Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaLOVpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:45:12 -0500
Received: from mail-bl2on0067.outbound.protection.outlook.com ([65.55.169.67]:60032
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751105AbaLOVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:45:10 -0500
Message-ID: <548F52B8.7030606@caviumnetworks.com>
Date: Mon, 15 Dec 2014 13:29:28 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Aleksey Makarov <feumilieu@gmail.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 14/14] MIPS: OCTEON: Handle OCTEON III in csrc-octeon.
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com> <1418666603-15159-15-git-send-email-aleksey.makarov@auriga.com> <20141215212422.GD10323@fuloong-minipc.musicnaut.iki.fi>
In-Reply-To: <20141215212422.GD10323@fuloong-minipc.musicnaut.iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.194]
X-ClientProxiedBy: BLUPR07CA073.namprd07.prod.outlook.com (25.160.24.28) To
 BY1PR0701MB1111.namprd07.prod.outlook.com (25.160.104.21)
Authentication-Results: iki.fi; dkim=none (message not signed) header.d=none;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0701MB1111;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:BY1PR0701MB1111;
X-Forefront-PRVS: 04267075BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(479174004)(377454003)(199003)(51704005)(24454002)(47776003)(54356999)(64706001)(80316001)(87976001)(33656002)(87266999)(92566001)(42186005)(120916001)(50986999)(110136001)(66066001)(106356001)(97736003)(105586002)(81156004)(107046002)(23756003)(122386002)(36756003)(62966003)(69596002)(99396003)(76176999)(68736005)(31966008)(77156002)(101416001)(83506001)(20776003)(46102003)(50466002)(40100003)(21056001)(64126003)(4396001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0701MB1111;H:dl.caveonetworks.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0701MB1111;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 01:24 PM, Aaro Koskinen wrote:
> Hi,
>
> On Mon, Dec 15, 2014 at 09:03:20PM +0300, Aleksey Makarov wrote:
>>   	if (current_cpu_type() == CPU_CAVIUM_OCTEON2) {
>>   		union cvmx_mio_rst_boot rst_boot;
>> +
>>   		rst_boot.u64 = cvmx_read_csr(CVMX_MIO_RST_BOOT);
>>   		rdiv = rst_boot.s.c_mul;	/* CPU clock */
>>   		sdiv = rst_boot.s.pnr_mul;	/* I/O clock */
>>   		f = (0x8000000000000000ull / sdiv) * 2;
>> +	} else if (current_cpu_type() == CPU_CAVIUM_OCTEON3) {
>> +		union cvmx_rst_boot rst_boot;
>> +
>> +		rst_boot.u64 = cvmx_read_csr(CVMX_RST_BOOT);
>> +		rdiv = rst_boot.s.c_mul;	/* CPU clock */
>> +		sdiv = rst_boot.s.pnr_mul;	/* I/O clock */
>> +		f = (0x8000000000000000ull / sdiv) * 2;
>>   	}
>
> The f = ... part could be moved outside the if blocks to avoid copy paste.
>

No, If you look at the rest of the file, you will find that there are 
checks in the form:

   if (f != 0) ...

There is a reason that we leave f with its default value of zero in some 
of the cases.

David Daney

