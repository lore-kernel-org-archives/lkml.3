Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3COCv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:51:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45839 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3COCvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:51:18 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-97-51428ca2da3c
Message-id: <51428CAA.5000302@samsung.com>
Date: Fri, 15 Mar 2013 11:51:22 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Sergey Yanovich <ynvich@gmail.com>, Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
 <1363224194-7366-1-git-send-email-ynvich@gmail.com>
 <CAKYAXd_v5TsMJ+h3Zk4FRDB0jAfF04t4Z65D1kmB1ziOk65+Vg@mail.gmail.com>
In-reply-to: <CAKYAXd_v5TsMJ+h3Zk4FRDB0jAfF04t4Z65D1kmB1ziOk65+Vg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zTd1FPU6BBmc2c1psf72RzaJ58Xo2
	i+t3bzFbTPmznMni8q45bBZH/vczWhxfG27Rf1nNgcNj56y77B6Hrqxl9LhzbQ+bx/65a9g9
	Pm+SC2CN4rJJSc3JLEst0rdL4Mo4dGABc8EWroo3vRuYGxi/sncxcnJICJhITPk5iQ3CFpO4
	cG89kM3FISSwjFHiwPpdLF2MHGBF764wQsSnM0qsbb/DAtIgJPCSUeLEHGYQm1dAS2L+yj9g
	NouAqsTJLcvBatgEdCS2fzvOBGKLCoRJrJx+hQWiXlDix+R7YPNFBNQkJjxLBZnPLNDKJLHw
	zhOwg4QFPCSeP1jLDrF4D6PEx+tzwa7mFAiWeHftJtgyZgF1iUnzFkHZ8hKb17xlBmmQELjF
	LnFtznQ2iIsEJL5NPgT1jazEpgPMEB9LShxccYNlAqPYLCQ3zUIydhaSsQsYmVcxiqYWJBcU
	J6UXGesVJ+YWl+al6yXn525ihERf/w7GuwesDzEmA62cyCwlmpwPjN68knhDYzMjC1MTU2Mj
	c0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB6X7JJ+/qlW/pRv/rDp3r+
	Vw4kuP7MyirvXrGqPsV+yc55F3V+eXpNf2U2bUZS5Ofj5dYO95dzprIwJi1bo/p97TO3fcfM
	yxYnTBStDZB9seIy/wR17v1nZxVf5W/RfSmQKHiWX/G26gmHXVf3Vc24ujRJJv/t5z6jh2fE
	3H5YHClvP9pfMMlbiaU4I9FQi7moOBEA/vTWbNQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd1FPU6BBhenMVtsf72RzaJ58Xo2
	i+t3bzFbTPmznMni8q45bBZH/vczWhxfG27Rf1nNgcNj56y77B6Hrqxl9LhzbQ+bx/65a9g9
	Pm+SC2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAE6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcejAAuaCLVwVb3o3
	MDcwfmXvYuTgkBAwkXh3hbGLkRPIFJO4cG89WxcjF4eQwHRGibXtd1hAEkICLxklTsxhBrF5
	BbQk5q/8A2azCKhKnNyyHKyGTUBHYvu340wgtqhAmMTK6VdYIOoFJX5MvscCsktEQE1iwrNU
	kPnMAq1MEgvvPGEDqREW8JB4/mAtO8TiPYwSH6/PZQdJcAoES7y7dhNsGbOAusSkeYugbHmJ
	zWveMk9gFJiFZMcsJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc28+kdjCu
	bLA4xCjAwajEw3ug3yFQiDWxrLgy9xCjBAezkgivp5djoBBvSmJlVWpRfnxRaU5q8SHGZGAQ
	TGSWEk3OB6advJJ4Q2MTMyNLIzNjE3NjY9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg
	9OFoYr8r8fHG1oYUvvqqzfUajn3SXw/op25eF+21aEo81+RPX5ju7vq4PXVDEvvWqKZpzev9
	H++c6PUv2/yF3fbmLNuzvsIuzCsbo/bsYf6mGCy3fs71imRh1Yq4buX8naYMLx7rcXV/Czbb
	0THNODD5ErOrzLa5X3/JrPtfeEp8paz0qqVblFiKMxINtZiLihMBZbEA8zEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 01:08 PM, Namjae Jeon wrote:
> 2013/3/14, Sergey Yanovich <ynvich@gmail.com>:
>> MMC hosts are added asynchronously. We need to wait until detect returns to
>> avoid failed root filesystem mounts.
>> ---8<---
>> VFS: Cannot open root device "mmcblk0p1" or unknown-block(0,0): error -6
>> Please append a correct "root=" boot option; here are the available
>> partitions:
>> mmc0: host does not support reading read-only switch. assuming
>> write-enable.
>> 1f00             256 mtdblock0  (driver?)
>> 1f01             256 mtdblock1  (driver?)
>> 1f02            2560 mtdblock2 mmc0: new SDHC card at address b368
>>  (driver?)
>> 1f03           29696 mtdblock3  (driver?)
>> 1f04           16384 mtdblock4 mmcblk0: mmc0:b368 USD   3.72 GiB
>>  (driver?)
>>  mmcblk0: p1
>> b300         3910656 mmcblk0  driver: mmcblk
>>   b301         3906560 mmcblk0p1 00000000-01
>> Kernel panic - not syncing: VFS: Unable to mount root fs on
>> unknown-block(0,0)
>> ---8<---
>>
>> Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
>> ---
> Hi.
> Have you ever tried to use rootwait or rootdelay on command line ?
> If no, You can use them.
I agreed the Namjae's suggestion..if you use the rootwait or rootdelay, it's waiting for mounting rootfs.

Best Regards,
Jaehoon Chung
> 
> Thanks.
> 

