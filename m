Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaLZTQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 14:16:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27487 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751127AbaLZTQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 14:16:44 -0500
Message-ID: <549DB410.8000002@fb.com>
Date: Fri, 26 Dec 2014 14:16:32 -0500
From: Alex Gartrell <agartrell@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH net-next 2/2] tun: enable socket system calls
References: <1419576624-8999-1-git-send-email-agartrell@fb.com> <1419576624-8999-3-git-send-email-agartrell@fb.com> <549D2DBE.5040301@redhat.com>
In-Reply-To: <549D2DBE.5040301@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-26_07:2014-12-24,2014-12-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.919135270856499 urlsuspect_oldscore=0.919135270856499
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.919135270856499 spamscore=0
 recipient_to_sender_domain_totalscore=1 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412260208
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

Thanks for commenting.

On 12/26/14 4:43 AM, Jason Wang wrote:
>
> On 12/26/2014 02:50 PM, Alex Gartrell wrote:
>> By setting private_data to a socket and private_data_is_socket to true, we
>> can use the socket syscalls.  We also can't just blindly use private_data
>> anymore, so there's a __tun_file_get function that returns the container_of
>> private_data appropriately.
>
> So this in fact expose other socket syscalls to userspace. But some of
> proto_ops was not supported. E.g consider what happens if a bind() was
> called for tun socket?

Yeah, I erroneously assumed that NULL => sock_no_*, but a quick glance 
assures me that that's not the case.  In this case, I'd need to 
introduce another patch that sets all of the additional ops to sock_no_*.

>> +static struct tun_file *tun_file_from_file(struct file *file)
>> +{
>> +	struct socket *s = (struct socket *)file->private_data;
>> +
>> +	if (!s)
>
> Can s be NULL here? If yes, why tun_get() didn't check for NULL?

This check is just to ensure that tun_get_socket continues to work in 
the right way when passed a file with private_data set to NULL.

Thanks,
-- 
Alex Gartrell <agartrell@fb.com>
