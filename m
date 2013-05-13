Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3EMPS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:18:26 -0400
Received: from MX2.LL.MIT.EDU ([129.55.12.46]:41359 "EHLO mx2.ll.mit.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3EMPSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:18:25 -0400
Message-ID: <51910436.6070509@ll.mit.edu>
Date: Mon, 13 May 2013 11:18:14 -0400
From: David Oostdyk <daveo@ll.mit.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130412 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: high-speed disk I/O is CPU-bound?
References: <518CFE7C.9080708@ll.mit.edu> <1368377617.18069.228@driftwood>
In-Reply-To: <1368377617.18069.228@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-05-13_02:2013-05-13,2013-05-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1211240000 definitions=main-1305130134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/13 12:53, Rob Landley wrote:
> On 05/10/2013 09:04:44 AM, David Oostdyk wrote:
>> Hello,
>>
>> I have a few relatively high-end systems with hardware RAIDs which
>> are being used for recording systems, and I'm trying to get a better
>> understanding of contiguous write performance.
> ...
>> The question is, is it possible that high-speed I/O to these hardware
>> RAIDs could
>> actually be CPU-bound above ~1400MB/sec?
> In some setups your processor is calculating CRCs for the data. It's a
> fairly cheap operation, but a cheap operation on gigabytes of data can
> still saturate your memory bus.
>
> Rob

At what level would you say this calculation is being applied? Somewhere 
in the block/filesystem layer, or in the device driver, or at the 
hardware level?  I'm seeing write speeds that are about 1/4 the memory 
bandwidth of a single thread, which would suggest at least one 
"additional" pass through the data before it gets DMA'd out.



