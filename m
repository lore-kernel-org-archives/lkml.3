Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbaICNRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:17:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46926 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbaICNRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:17:11 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-0a-540714d4b29b
Message-id: <54071425.7000506@samsung.com>
Date: Wed, 03 Sep 2014 16:14:13 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 2/8] integrity: remove declaration of non-existing functions
References: <cover.1409728712.git.d.kasatkin@samsung.com>
 <4ae21fa095c234dcb8f6b6ebb7b7fff308448fb8.1409728712.git.d.kasatkin@samsung.com>
 <1409748660.21827.55.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1409748660.21827.55.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xa7pXRNhDDGY8krb4srTO4uWMeewW
	l3fNYbP40POIzeLTiknMDqweO2fdZfd4cGgzi8fuBZ+ZPD5vkgtgieKySUnNySxLLdK3S+DK
	eLnoLXvBdJGKyVMDGhh/CXQxcnJICJhIXG6ZwQ5hi0lcuLeerYuRi0NIYCmjRNOC86wgCSGB
	RiaJ7XOgErMYJZ7vvsAGkuAV0JJofzwPqIiDg0VAVWLbWy2QMJuAnsSG5h9gQ0UFwiSe/TrI
	BFEuKPFj8j0WEFtEQFPiWOtHRpCZzAK9jBL96/qYQRLCAgESs9a3s0EsPsUo8e2ADYjNKeAh
	8WDPDTaQXcwC6hJTpuSChJkF5CU2r3nLDFGuKtG9di0bxDOKEqcnn2OewCg8C8nqWQjds5B0
	L2BkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREglfdzAuPWZ1iFGAg1GJhzdCkC1EiDWx
	rLgy9xCjBAezkgivJjN7iBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGj7V/HzPf+Nm/wurassMn
	r3CEFpxbcKNUK7f8zgVFscQNbb7zGLjr+BVPvFZ6y2ChZp/Q6Gjm6cbPufr9xLBC9ZNJyyev
	XVyyzfbcBeGPa+T3nIm02lkZ+y4/LlRSZNJVCeuQrWK5JzfFndBJW77s5tE7lXkTgmrjcpp+
	cWXF7O/u3cvyoqVViaU4I9FQi7moOBEAz6jk42ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 15:51, Mimi Zohar wrote:
> On Wed, 2014-09-03 at 10:19 +0300, Dmitry Kasatkin wrote: 
>> Noticed that there are declaration of few non-existing functions.
>> Also remove duplicated declaration of inegrity_iint_find().
> Please include the commits, which removed these functions, in the patch
> description.

Do you think it is really necessary?

Anyway.
f381c272224f5f158f5cff64f8f3481fa0eee8b3 integrity: move ima inode
integrity data management

- Dmitry

> Mimi
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  security/integrity/ima/ima.h   | 9 ---------
>>  security/integrity/integrity.h | 1 -
>>  2 files changed, 10 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
>> index 0fb456c..c6990a7 100644
>> --- a/security/integrity/ima/ima.h
>> +++ b/security/integrity/ima/ima.h
>> @@ -90,10 +90,7 @@ extern struct list_head ima_measurements;	/* list of all measurements */
>>
>>  /* Internal IMA function definitions */
>>  int ima_init(void);
>> -void ima_cleanup(void);
>>  int ima_fs_init(void);
>> -void ima_fs_cleanup(void);
>> -int ima_inode_alloc(struct inode *inode);
>>  int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>>  			   const char *op, struct inode *inode,
>>  			   const unsigned char *filename);
>> @@ -151,12 +148,6 @@ int ima_store_template(struct ima_template_entry *entry, int violation,
>>  void ima_free_template_entry(struct ima_template_entry *entry);
>>  const char *ima_d_path(struct path *path, char **pathbuf);
>>
>> -/* rbtree tree calls to lookup, insert, delete
>> - * integrity data associated with an inode.
>> - */
>> -struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
>> -struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
>> -
>>  /* IMA policy related functions */
>>  enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK, FIRMWARE_CHECK, POST_SETATTR };
>>
>> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
>> index 904e68a..c0379d1 100644
>> --- a/security/integrity/integrity.h
>> +++ b/security/integrity/integrity.h
>> @@ -117,7 +117,6 @@ struct integrity_iint_cache {
>>  /* rbtree tree calls to lookup, insert, delete
>>   * integrity data associated with an inode.
>>   */
>> -struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
>>  struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
>>
>>  #define INTEGRITY_KEYRING_EVM		0
>
>

