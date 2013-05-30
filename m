Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3E3UT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:19:56 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:55809 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3E3UTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:19:37 -0400
X-WSS-ID: 0MNMOGM-0B-186-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <51A7B442.9010108@sandia.gov>
Date: Thu, 30 May 2013 14:19:14 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Weston Andros Adamson" <dros@netapp.com>,
        "Chuck Lever" <chuck.lever@oracle.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.10-rc3 NFSv3 mount issues
X-TMWD-Spam-Summary: TS=20130530201915; ID=1; SEV=2.3.1;
 DFV=B2013022509; IFV=NA; AIF=B2013022509; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230352E35314137423434342E303034303A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2013022509_5.03.0010
X-WSS-ID: 7DB96BC92IW3327949-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been trying to test 3.10-rc3 on some diskless clients, and found
that I can no longer mount my root file system via NFSv3.

I poked around looking at NFS changes for 3.10, and found these two
commits:

 d497ab9751 "NFSv3: match sec= flavor against server list"
 4580a92d44 "NFS: Use server-recommended security flavor by default (NFSv3)"

If I revert both of these commits from 3.10-rc3, then my diskless
client can mount its root file system.

The busybox mount command fails like this, when using 3.10-rc3:

/ # mount  -t nfs -o ro,nolock,vers=3,proto=tcp 172.17.0.122:/gmi/images/jaschut/ceph.toss-2x /mnt
mount: mounting 172.17.0.122:/gmi/images/jaschut/ceph.toss-2x on /mnt failed: Invalid argument

The commit messages for both these commits seem to say that mounting
with the "sys=sec" option should work, but unfortunately, my busybox doesn't
seem to understand the "sec=" mount option:

/ # mount  -t nfs -o ro,nolock,vers=3,proto=tcp,sec=sys 172.17.0.122:/gmi/images/jaschut/ceph.toss-2x /mnt
mount: invalid number 'sys'

My NFS server is based on RHEL6, and is not using any "sec=" option
in its export for this file system.  I did try exporting with "sec=sys",
but it didn't seem to make any difference either.

So far, this seems like a regression to me ....
Any ideas what I might be doing wrong?  How can I
help make this work again?

Thanks -- Jim

