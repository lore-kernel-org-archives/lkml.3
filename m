Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3KECjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:39:15 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:35092 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3KECjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:39:11 -0500
X-Authority-Analysis: v=2.0 cv=KJLY/S5o c=1 sm=0 a=3SewDSjaRW4vdJyuxQ33ZQ==:17 a=DeBnktw0k-IA:10 a=AizhB-pfR1kA:10 a=knnhOU_jrMgA:10 a=S1A5HrydsesA:10 a=IkcTkHD0fZMA:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=qoLslf_BdD4A:10 a=QfKxxUxMAAAA:8 a=z9AJbDmSy-eY_1qqa8cA:9 a=QEXdDO2ut3YA:10 a=3SewDSjaRW4vdJyuxQ33ZQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 72.238.73.171
Message-ID: <52785A4E.7080006@ubuntu.com>
Date: Mon, 04 Nov 2013 21:39:10 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>, linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 1/2] libata: use sleep instead of standby command
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com> <527856B6.8030901@intel.com>
In-Reply-To: <527856B6.8030901@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/04/2013 09:23 PM, Aaron Lu wrote:
> I suppose this is mainly for runtime PM? Since for system 
> suspend/hibernation, the disk and its controller will be powered
> off anyway.

Yes, or the second patch also helps when one manually issues hdparm
- -Y, which otherwise will cause the drive to be woken up to answer the
CHECK POWER command, which udisks issues to decide if it should skip
polling the SMART status of the drive.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSeFpOAAoJEJrBOlT6nu75JdwIALFvwncNyf1ENxnIho2Y3CXC
N6BpHQ7CzD1tap/5ybSFPBvUvJfyC/UPAY69bjldOtbwnArDIWRFqEWW7JWm6G0z
J1C5MMCIRHSuRo4RbN/rnsPQFsaFJy0Z5kJ0uXX+aOrZwEov5vo2MEuj/DEdCBDC
SKpYkogDlSHTNhFsaEF5iJiJlLU9FF5pEM6S6P0/+Z+SrZ5PVCDOm9rK+oeqrn0U
TBX5tKPxWRSjJ/2F094DYia5l8ODNgzl1gPDXA50a+A4M0CZi3d5Liz5Ctfnv88A
ac5cG8Ae8MDss0kJmSMCuRwkKVIROM3qMxf1wDWjBwm3eCTAJV1gxRYSN0adOvc=
=Rfny
-----END PGP SIGNATURE-----
