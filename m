Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaJCKnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:43:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28272 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJCKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:43:00 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-6e-542e7db298fd
Message-id: <542E7DB4.2030206@samsung.com>
Date: Fri, 03 Oct 2014 13:43:00 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: dhowells@redhat.com, keyrings@linux-nfs.org
Cc: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 0/4] KEYS fixes
References: <cover.1412327306.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xa7qbavVCDA6cYbJ41/SbxeLL0jqL
	desXM1nM3vWQxeLljHnsFpd3zWGz+NDziM3i5rQLLBafVkxiduD02DnrLrvHtBPLWDweHNrM
	4rF7wWcmj57vyR7v911l81ix4QSzx+dNcgEcUVw2Kak5mWWpRfp2CVwZj/5sZyzYyVlx4EVJ
	A+MO9i5GTg4JAROJBSe/s0DYYhIX7q1n62Lk4hASWMoosev9RSinkUnifs9cJghnFqPElTVX
	GEFaeAW0JPoOX2ECsVkEVCVu7PjFCmKzCehJbGj+AbZCVCBC4uTdPewQ9YISPybfA1snIqAv
	MeNfPyPIUGaBi4wSn7bfAxrEwSEsoCwx87ALSI2QgKXE+v4VYL2cAlYSW65uYAMpYQaaf/+i
	FkiYWUBeYvOat8wQ5aoS3WvXskF8oyhxevI55gmMwrOQbJ6F0D0LSfcCRuZVjKKppckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGCGR9XUH49JjVocYBTgYlXh4P9zQDRFiTSwrrsw9xCjBwawkwvur
	QC9EiDclsbIqtSg/vqg0J7X4ECMTB6dUA+Ot8rjlQeczb4p8DFk5/c7Rqz1aWvy6m3ReTRUK
	sb2nvGR6NkvB8itGBw8sUwmanLx958aCuZ+ctrwOjc1vqmreG1+jmLTddGuLSFvw+ra8C34n
	lX7PqDJ4YyjovuS8k83aiJMGTavnnf6u/uL9863sZWt+pn5I/hGxUNJB4FR8yo7JX6p5b6op
	sRRnJBpqMRcVJwIAdg3sAooCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I slightly update what I posted and added one fix and one suggestion on
the top.

Here is those patches on the top of Jame's tree...

http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/log/?h=keys-fixes

- Dmitry

On 03/10/14 12:09, Dmitry Kasatkin wrote:
> I reported yesterday problems with new KEYS.
> Module signature verification is broken, integrity subsystem verification is
> broken, kernel oopses.
>
> Here is few fixes.
>
> - Dmitry
>
> Dmitry Kasatkin (4):
>   KEYS: handle error code encoded in pointer
>   KEYS: provide pure subject key identifier (fingerprint) as key id
>   module: search the key only by keyid
>   integrity: do zero padding of the key id
>
>  crypto/asymmetric_keys/asymmetric_type.c  | 27 ++++++++++++++++++++++++---
>  crypto/asymmetric_keys/x509_cert_parser.c |  6 ++++++
>  crypto/asymmetric_keys/x509_parser.h      |  1 +
>  crypto/asymmetric_keys/x509_public_key.c  |  2 ++
>  include/keys/asymmetric-type.h            |  2 +-
>  kernel/module_signing.c                   | 16 +++++-----------
>  security/integrity/digsig_asymmetric.c    |  2 +-
>  7 files changed, 40 insertions(+), 16 deletions(-)
>

