Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbbANUrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:47:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40805 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbbANUrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:47:14 -0500
Date: Wed, 14 Jan 2015 12:46:53 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-ID: <20150114204653.GA26698@mail.thefacebook.com>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <20150114152501.GB9820@node.dhcp.inet.fi>
 <20150114153323.GF2253@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150114153323.GF2253@moon>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_05:2015-01-14,2015-01-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.128698695412054 urlsuspect_oldscore=0.128698695412054
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.128698695412054 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501140204
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01/14 at 18:33 +0300, Cyrill Gorcunov wrote:
> On Wed, Jan 14, 2015 at 05:25:01PM +0200, Kirill A. Shutemov wrote:
> ...
> > > 
> > > This gives lsof and suchlike a way to determine the pathnames of files
> > > mapped into a process without incurring the O(N^2) behavior of the
> > > maps file.
> > 
> > We already have /proc/PID/map_files/ directory which lists all mapped
> > files. Should we consider relaxing permission checking there and move it
> > outside CONFIG_CHECKPOINT_RESTORE instead?
> > 
> > Restriction to CAP_SYSADMIN for follow_link is undertansble, but why do we
> > restrict readdir and readlink?
> 
> We didn't think this functionality might be needed someone but us (criu camp),
> so that the rule of thumb was CONFIG_CHECKPOINT_RESTORE + CAP_SYSADMIN, until
> otherwise strictly needed. So I think now we can relax security rules a bit
> and allow to readdir and such for owners.

Ah, I feel silly for missing that. I'll send a patch to move map_files
out from behind CONFIG_CHECKPOINT_RESTORE and change the permissions.

Thanks,
Calvin
