Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaLZUAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 15:00:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26383 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbaLZUAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 15:00:15 -0500
Message-ID: <549DBE25.3040302@fb.com>
Date: Fri, 26 Dec 2014 14:59:33 -0500
From: Alex Gartrell <agartrell@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH net-next 1/2] socket: Allow external sockets to use socket
 syscalls
References: <1419576624-8999-1-git-send-email-agartrell@fb.com> <1419576624-8999-2-git-send-email-agartrell@fb.com> <20141226195650.GF22149@ZenIV.linux.org.uk>
In-Reply-To: <20141226195650.GF22149@ZenIV.linux.org.uk>
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
 definitions=main-1412260217
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Al,

On 12/26/14 2:56 PM, Al Viro wrote:
> On Thu, Dec 25, 2014 at 10:50:23PM -0800, Alex Gartrell wrote:
>> Currently the "is-socket" test for a file compares the ops table pointer,
>> which is static and local to the socket.c.  Instead, this adds a flag for
>> private_data_is_socket.  This is an exceptionally long commit message for a
>> two-line patch.
>
> NAK.  Don't crap into struct file, please.
>

I don't disagree with your sentiment here.  Is the additional f_op 
approach less gross or do you have something else in mind?

Thanks,
-- 
Alex Gartrell <agartrell@fb.com>
