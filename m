Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaKYNJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:09:19 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10131 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbaKYNJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:09:15 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-df-54747f776dc3
Message-id: <54747F74.8070808@samsung.com>
Date: Tue, 25 Nov 2014 16:09:08 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Dmitry Chernenkov <dmitryc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/12] lib: add kasan test module
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-12-git-send-email-a.ryabinin@samsung.com>
 <CAA6XgkEZD=+TvqXmO814nYi_oqp_3F7_NvkjEW0-X262xTiRDw@mail.gmail.com>
In-reply-to: <CAA6XgkEZD=+TvqXmO814nYi_oqp_3F7_NvkjEW0-X262xTiRDw@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xy7rl9SUhBi/+KVn83juT1WLO+jVs
	FkeufWe3uP7tDaPFp5cPGC22XG9isnj+8CG7xYSHbewW0zaKW6zsbmaz2P7sLZPFys4HrBaX
	d81hs7i35j+rxeIjt5kt3j2bzGxxddVBdosfGx6zOgh5zN/5kdFj56y77B4LNpV6LN7zkslj
	06pONo9Nnyaxe3S9vcLkcWLGbxaPJ1emM3l8fHqLxeP9vqtsHp83yXmcaPnCGsAbxWWTkpqT
	WZZapG+XwJUx8+Bu5oJb3BUTt1xiamDcx9nFyMkhIWAi8e9wIyOELSZx4d56ti5GLg4hgaWM
	Evs2vmWFcJqZJDbNXcQGUsUroCWxaM1rZhCbRUBV4sCbtywgNpuAnsS/WdvBakQFIiSurJnD
	CFEvKPFj8j2wGhGg3vMfHoANZRa4xyIxre8CO0hCWMBC4u+ee0wQ21qZJPY+vQ02iVMgWGL/
	sX1ACQ6gDnWJKVNyQcLMAvISm9e8ZZ7AKDALyY5ZCFWzkFQtYGRexSiaWppcUJyUnmukV5yY
	W1yal66XnJ+7iRESoV93MC49ZnWIUYCDUYmH90ZcSYgQa2JZcWXuIUYJDmYlEd7caqAQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGxuvduaLvo7hmHmi8d0kjOEwsffFs/7aHP9QEt/7Sl12/6mdG
	wwPDukM3f4g7PUtfXhzzJzpReHdBrLhM3yT2ZRkxh7Zv4a9bO+XMvVPKwm9fhghf5P79cMX2
	zVdUrT+unetw+8G0XVtNE/bPC0x5rbfPRTeUvzH2bNrDrZalv/MlvQ+FSJ/f9lmJpTgj0VCL
	uag4EQDZlLnQrgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 02:14 PM, Dmitry Chernenkov wrote:
> I have a bit of concern about tests.
> A) they are not fully automated, there is no checking whether they
> pass or not. This is implemented in our repository using special tags
> in the log (https://github.com/google/kasan/commit/33b267553e7ffe66d5207152a3294112361b75fe;
> don't mmind the TODOs, they weren't broken to begin with), and a
> parser script (https://code.google.com/p/address-sanitizer/source/browse/trunk/tools/kernel_test_parse.py)
> to feed the kernel log to.
> 
> B) They are not thorough enough - they don't check false negatives,

False negative means kasan's report on valid access, right? Most of the memory accesses
in kernel are valid, so just booting kernel should give you the best check for false
negatives you can ever write.

Though I agree that it's not very thorough. Currently this more demonstrational module,
and there are a lot of cases not covered by it.

> accesses more than 1 byte away etc.
> 
> C) (more of general concern for current Kasan realiability) - when
> running multiple times, some tests are flaky, specificially oob_right
> and uaf2. The latter needs quarantine to work reliably (I know
> Konstantin is working on it). oob_right needs redzones in the
> beginning of the slabs.
> 
> I know all of these may seem like long shots, but if we want a
> reliable solution (also a backportable solution), we need to at least
> consider them.
> 
> Otherwise, LGTM
> 


