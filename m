Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaBNCBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:01:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52720 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaBNCBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:01:42 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f266d00000287c-39-52fd79058146
Content-transfer-encoding: 8BIT
Message-id: <1392343210.25542.115.camel@kjgkr>
Subject: Re: [f2fs-dev] f2fs: f2fs unmount hangs if f2fs_init_acl() fails
 during mkdir syscall
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Date: Fri, 14 Feb 2014 11:00:10 +0900
In-reply-to: <52FC94D0.2050705@cn.fujitsu.com>
References: <52F320FC.50803@ispras.ru> <1391666564.25542.78.camel@kjgkr>
 <52F37D67.208@ispras.ru> <1391734185.25542.80.camel@kjgkr>
 <1391749933.25542.83.camel@kjgkr> <52F9DF85.7040402@ispras.ru>
 <52FC832F.6000103@cn.fujitsu.com> <52FC9315.2090707@ispras.ru>
 <52FC94D0.2050705@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zY13Wyr9BBosaZC2etx9gtri0yN3i
	8q45bBbLL8c5sHj8PziJ2WPGv6mMHrsXfGby+LxJLoAlissmJTUnsyy1SN8ugSvj7OTTTAUL
	OCpmf+xmbGCcxNbFyMkhIWAicXn/N3YIW0ziwr31QHEuDiGBZYwSp678hit6uns7E0RiEaPE
	voObwDp4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcwQ9S8ZJRZ3XWWFqNeTmHjnJwuI
	LSyQIDH15m2wXjYBbYnN+w1AwkICihJv998FKxcRUJN49u4SE8TMRkaJH9PjQGwWAVWJ2Tvn
	gsU5gUa+ffQaatdqJommLw2MIAl+AVGJwwu3M0M8oCSxu72THaRIQuAUu8T+rVvZISYJSHyb
	fAjsCAkBWYlNB6DqJSUOrrjBMoFRYhaSN2chvDkLyZsLGJlXMYqmFiQXFCelF5noFSfmFpfm
	pesl5+duYoRE3oQdjPcOWB9iTAbaOJFZSjQ5Hxi5eSXxhsZmRhamJqbGRuaWZqQJK4nzqj1K
	ChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKQWM4Eu3tpXGzW1xD+JJmfrhVO/PWuMX/5873wyb
	6nT+vJCE7/OSnRudvGwbMo2UBFjsYopS2MwPbMzkW8bD4BZ95LjrI5moOmmN8K3lcpv1g6dm
	il84sZBl7tcZ6lxiP1WSsjWajxxV333z2JXOhzuZ9xTfNeKcvHxVrFOV0E+Tx5bSSzMmMwor
	sRRnJBpqMRcVJwIAeSvDcNICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAV3Wyr9BBl92SFo8bz/AbHFpkbvF
	5V1z2CyWX45zYPH4f3ASs8eMf1MZPXYv+Mzk8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxtnJp5kKFnBUzP7YzdjAOImti5GTQ0LAROLp7u1MELaYxIV764Hi
	XBxCAosYJfYd3MQOkuAVEJT4MfkeSxcjBwezgLzEkUvZIGFmAXWJSfMWMUPUv2SUWNx1lRWi
	Xk9i4p2fLCC2sECCxNSbt8F62QS0JTbvNwAJCwkoSrzdfxesXERATeLZu0tMEDMbGSV+TI8D
	sVkEVCVm75wLFucEGvn20WuoXauZJJq+NDCCJPgFRCUOL9zODPGAksTu9k72CYxCs5CcPQvh
	7FlIzl7AyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziun0nvYFzVYHGIUYCDUYmH1+PB
	nyAh1sSy4srcQ4wSHMxKIrxMaX+DhHhTEiurUovy44tKc1KLDzEmA10+kVlKNDkfmHLySuIN
	jU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoHR+OVftneT1yS+PqhV
	wFJTvlZd/3fdufwfz1WcPFYtlD+QczTvH9fJSK9jmtdfX33LHnG36Fa6hP25PsEihZcd7FFn
	TV++aJmxUejPz+fCUfzHFlXGbXZ8dO/Ehg/u2uKZRhF5q5fOvCv8c/uL8IktVX/E7kueLGXR
	ny618IOw32Fd60e5Ds2zlViKMxINtZiLihMBYtoRnC8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-02-13 (목), 17:48 +0800, Gu Zheng:
> Hi,
> On 02/13/2014 05:40 PM, Andrey Tsyvarev wrote:
> 
> > Hi,
> > 
> >> BTW, have you tested the case that added remove_dirty_dir_inode() into the fail path
> >> of init_inode_metadata?
> >> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> >> index e095a4f..d5a2c9e 100644
> >> --- a/fs/f2fs/dir.c
> >> +++ b/fs/f2fs/dir.c
> >> @@ -375,6 +375,7 @@ put_error:
> >>          /* once the failed inode becomes a bad inode, i_mode is S_IFREG */
> >>          truncate_inode_pages(&inode->i_data, 0);
> >>          truncate_blocks(inode, 0);
> >> +       remove_dirty_dir_inode(inode);
> >>   error:
> >>          remove_inode_page(inode);
> >>          return ERR_PTR(err);
> > Yes, i have tested that case. Fail in init_inode_metadata has been processed correctly. Thanks.
> 
> If no other regressions, maybe you can send out the fix patch about this issue.:)

The original patch can treat this too.
Thank you. :)

> 
> Thanks,
> Gu
> 
> > 
> 
> 

-- 
Jaegeuk Kim
Samsung

