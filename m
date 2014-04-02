Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbaDBTnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:43:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37855 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933029AbaDBTno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:43:44 -0400
Message-ID: <533C6871.7060003@fb.com>
Date: Wed, 2 Apr 2014 15:43:45 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <dsterba@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>, <jbacik@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Btrfs lockdep with 3.15 merge window v3.14-751-g683b6c6f82a6
References: <CA+5PVA787+k0TVFUuo6PxNWMwffWDKixmt2C+E4_9szUJatYkw@mail.gmail.com> <20140402164709.GI29256@twin.jikos.cz>
In-Reply-To: <20140402164709.GI29256@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-02_05:2014-04-02,2014-04-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=4.94049245958195e-15 kscore.compositescore=0
 circleOfTrustscore=3.17628122076682 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404020160
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 12:47 PM, David Sterba wrote:
> On Tue, Apr 01, 2014 at 06:23:11PM -0400, Josh Boyer wrote:
>> Below is a lockdep spew I have on a local VM running Linus' tree as of
>> this afternoon.  The specific git commit is v3.14-751-g683b6c6f82a6.
>
>> [  295.349016]        CPU0                    CPU1
>> [  295.349016]        ----                    ----
>> [  295.349016]   lock(&found->groups_sem);
>> [  295.349016]                                local_irq_disable();
>> [  295.349016]                                lock(&delayed_node->mutex);
>> [  295.349016]                                lock(&found->groups_sem);
>> [  295.349016]   <Interrupt>
>> [  295.349016]     lock(&delayed_node->mutex);
>
> Fixed by https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/3894781/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=R1vuFCUzlD4QksU2UH3APFiFgMVkwmMci%2Bktv%2BzqQnE%3D%0A&s=adbe2bfbb243d9781307cfff001f30c01afd35a32e0fb976ecca933ef4cebd26
>

I've got this lined up for my next pull as well.  I sent early this 
time, but more is going in.

-chris
