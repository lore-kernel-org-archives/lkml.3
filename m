Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaJXP5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:57:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17861 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJXP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:57:32 -0400
Date: Fri, 24 Oct 2014 17:58:43 +0200
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        stable@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Jamie Iles <jamie.iles@oracle.com>
Subject: Re: [PATCH 13/14] kvm: fix excessive pages un-pinning in
 kvm_iommu_map error path.
Message-ID: <20141024155843.GB29930@chrystal.home>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
 <1414163245-18555-14-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <1414163245-18555-14-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2014 at 05:07:24PM +0200, Paolo Bonzini wrote:
> From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> 
> The third parameter of kvm_unpin_pages() when called from
> kvm_iommu_map_pages() is wrong, it should be the number of pages to un-pin
> and not the page size.
> 

This got assigned CVE-2014-8369.

Quentin

--Pd0ReVV5GZGQvF3a
Content-Type: message/rfc822
Content-Disposition: inline

Received: from ucsinet22.oracle.com (/156.151.31.94)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 21 Oct 2014 01:13:17 -0700
Received: from userp1030.oracle.com (userp1030.oracle.com [156.151.31.80])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s9L8DGJm009253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Tue, 21 Oct 2014 08:13:17 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp1030.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s9L8DGwj012217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Tue, 21 Oct 2014 08:13:16 GMT
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.14.7/8.14.7) with SMTP id s9L8D4v1046310;
	Tue, 21 Oct 2014 08:13:16 GMT
Received: from smtptsrv1.mitre.org (smtptsrv1.mitre.org [192.52.194.77])
	by userp2040.oracle.com with ESMTP id 1q5jujrrc0-1;
	Tue, 21 Oct 2014 08:13:16 +0000
Received: from smtptsrv1.mitre.org (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 2ED33C5083C;
	Tue, 21 Oct 2014 04:13:15 -0400 (EDT)
Received: from rcf-smtp.mitre.org (linus.mitre.org [129.83.10.1])
	by smtptsrv1.mitre.org (Postfix) with ESMTP id DF6C1C5058D;
	Tue, 21 Oct 2014 04:13:14 -0400 (EDT)
Received: from faron.mitre.org (faron.mitre.org [129.83.10.2])
	by rcf-smtp.mitre.org (Postfix) with SMTP id B34EA18008B;
	Tue, 21 Oct 2014 04:12:30 -0400 (EDT)
From: cve-assign@mitre.org
To: quentin.casasnovas@oracle.com
Cc: cve-assign@mitre.org, security@kernel.org, mst@redhat.com,
        vegard.nossum@oracle.com, jamie.iles@oracle.com,
        sasha.levin@oracle.com
Subject: Re: CVE-2014-3601: incomplete upstream fix.
In-Reply-To: <20141021001315.GD31700@chrystal.home>
Message-Id: <20141021081314.DF6C1C5058D@smtptsrv1.mitre.org>
Date: Tue, 21 Oct 2014 04:13:14 -0400 (EDT)
X-Source-IP: 192.52.194.77
X-ServerName: smtptsrv1.mitre.org
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7597 signatures=670556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1410210091
X-Spam: Clean

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

> While reviewing Red Hat 6.6 kernel patches to prepare Ksplice rebootless
> updates, we've stumbled accross a potential issue with the upstream fix for
> CVE-2014-3601:

> 350b8bd kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)

> The above commit is supposed to prevent extra pages un-pinning _and_ fix a
> memory leak, but by fixing the memory leak in the error path, it likely
> introduces way more unwanted un-pinning

Use CVE-2014-8369.

- -- 
CVE assignment team, MITRE CVE Numbering Authority
M/S M300
202 Burlington Road, Bedford, MA 01730 USA
[ PGP key available through http://cve.mitre.org/cve/request_id.html ]
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (SunOS)

iQEcBAEBAgAGBQJURhP+AAoJEKllVAevmvmsnXAH/AjUWd/JB2f73+6N8rjNTL0u
Hn/FrVNRdML+g1bQJ263PnHCSS7Ix92nDKiQZ6BdE9k9hOOiNIrfEO+JZhgZzS40
cGZNO13SttajyA1FEUrQWC8y6rvcBuMMZOzIaAOrfeT/QmfgY554jSzb0yIoIOs5
RKHlfqxvUR42RjQf96S3RT/ey6P00sHW54RUs2evPHA9ec57g5EARSeoh9mpkozT
Q1S/ByHqdkvjP+lTE4swfYw9HO6vUNixMosOc4Us5fAZ0EvLDkwEWUdc88FJZl6s
faiJf5MAMePPE1kFNpvBaWl8umu5OTz46oHg+GV/lmA7SRIimPd0QaqL6G1tF3M=
=XEZP
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
