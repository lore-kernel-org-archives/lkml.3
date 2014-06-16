Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaFPMH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:07:56 -0400
Received: from mx0a-00176a03.pphosted.com ([67.231.149.52]:43026 "EHLO
	mx0a-00176a03.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbaFPMHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:07:55 -0400
X-Greylist: delayed 7160 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 08:07:54 EDT
Message-ID: <539EC21E.8030909@ge.com>
Date: Mon, 16 Jun 2014 11:08:30 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: nick <nickkrause@sympatico.ca>, <manohar.vanga@gmail.com>,
        <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFBBVENIW1t2bWUvYnJpZGdlcy92bWVfY2E5MWN4NDIuYzoxMzg=?=
 =?UTF-8?B?MjogQmFkIGlmIHRlc3QgQnVnIEZpeF3igI/igI8=?=
References: <BLU436-SMTP2404B87A72E455C1BDE2B43A52A0@phx.gbl> <539EBD2D.9030504@ge.com> <20140616095631.GN5015@mwanda>
In-Reply-To: <20140616095631.GN5015@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [3.159.212.192]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-15_03:2014-06-13,2014-06-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1406160097
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/14 10:56, Dan Carpenter wrote:
> On Mon, Jun 16, 2014 at 10:47:25AM +0100, Martyn Welch wrote:
>> Nick,
>>
>> Sorry for the delay in responding.
>>
>> I'm staring at the manual for the ca91c142 and the relevant bits in
>> the VSIx_CTL registers definitely need to be set to 0 for A16,
>> likewise with the LM_CTL register. The pattern (3<<16) would enable
>> one of the "reserved" address spaces.
>>
>
> Nick emailed me privately that this was a static checker warning.  These
> warnings are often false positives...  But I'm worried about the test:
>
> 	if ((ctl & CA91CX42_VSI_CTL_VAS_M) == CA91CX42_VSI_CTL_VAS_A16)
> 		*aspace = VME_A16;
>
> That could be true when we didn't intend it.
>

If I'm not mistaken, CA91CX42_VSI_CTL_VAS_A16 is currently defined as 0.

So:
	if ((ctl & (7<<16) == 0)
		*aspace = VME_A16;

Which looks right to me, it's checking to see if the relevant bits in 
the register are all zero, am I missing something obvious?

Martyn


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
