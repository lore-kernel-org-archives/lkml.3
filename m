Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaLVUSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:18:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7574 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764AbaLVUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:18:53 -0500
Message-ID: <54987C9F.5070103@fb.com>
Date: Mon, 22 Dec 2014 12:18:39 -0800
From: Alex Gartrell <agartrell@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <jasonwang@redhat.com>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mst@redhat.com>,
        <herbert@gondor.apena.org.au>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next] tun: support retrieving multiple packets
 in a single read with IFF_MULTI_READ
References: <20141222120957.GA21319@gondor.apana.org.au>
In-Reply-To: <20141222120957.GA21319@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-22_03:2014-12-22,2014-12-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.919135270856499 urlsuspect_oldscore=0.919135270856499
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.919135270856499 spamscore=0
 recipient_to_sender_domain_totalscore=1 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412220204
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Herbert,

Thanks for getting back to me

On 12/22/14 4:09 AM, Herbert Xu wrote:
> As tun already has a socket interface can we do this through
> recvmmsg?

This just presents an easier interface (IMHO) for accomplishing that. 
And I say easier because I was unable how to figure out the recvmmsg way 
to do it.

While fully aware that this makes me look like an idiot, I have to admit 
that I've tried and failed to figure out how to get a socket fd out of 
the tun device.

The regular fd doesn't work (which is obvious when you look at the 
implementation sock_from_file), there's a tun_get_socket function but 
it's only referenced by a single file, and none of the ioctl's jump out 
at me as doing anything to enable this behavior.  Additionally, 
tuntap.txt makes no mention of sockets specifically.

FWIW, I don't feel strongly that IFF_MULTI_READ is the right way to do 
this either.

Thanks,
-- 
Alex Gartrell <agartrell@fb.com>

