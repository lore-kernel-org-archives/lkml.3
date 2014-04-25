Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaDYOvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:51:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47268 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaDYOvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:51:03 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-a4-535a7656a28d
Message-id: <535A7690.30205@samsung.com>
Date: Fri, 25 Apr 2014 17:52:00 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, jmorris@namei.org, roberto.sassu@polito.it,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/20] ima: provide buffer hash calculation function
References: <cover.1398259638.git.d.kasatkin@samsung.com>
 <1b9253e91b214bb67d4fdd9297f9734d7c4cb6cc.1398259638.git.d.kasatkin@samsung.com>
 <1398373468.3395.83.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1398373468.3395.83.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xy7phZVHBBhsuclm8a/rNYrFu/WIm
	i8u75rBZfOh5xGbxctc3dotPKyYxO7B5PDi0mcWj53uyx+mVxR7v911l8/i8SS6ANYrLJiU1
	J7MstUjfLoEr49uOp4wFU0UrGlb9YWlgnCnYxcjJISFgIvH4YjcbhC0mceHeeiCbi0NIYCmj
	xMe/91khnEYmiYV3VzNBOLMYJTZP6mUEaeEV0JB4/v4xO4jNIqAqcWrXPLA4m4CexIbmH2Bx
	UYEIiXuNh1kh6gUlfky+xwJiiwhoShxr/cgIMpRZoItR4vLTY8xdjBwcwgIeEo9e2kMsO8ko
	8WXLWbBmTgF3iYe7fzOB2MwC6hKT5i1ihrDlJTaveQtmCwEd0b12LdQ/ihKnJ59jnsAoPAvJ
	7llI2mchaV/AyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyRKvu5gXHrM6hCjAAejEg/v
	CqPIYCHWxLLiytxDjBIczEoivNfyo4KFeFMSK6tSi/Lji0pzUosPMTJxcEo1MAqLvV3yx+aW
	imL/ueurszNFSiNfyKl+ntAu32HXGFNv9bVObuKXkM4lt6NZHl1f9Yc77MHcRi3h6xtqND17
	txfYyZYdU7RQVf7SdVuo5LdErPuTBu6jLsUZ0tvtd0axsa3d+O5sg967ectMHW/YrZba89hM
	4x7j/6Tp6UF+E6sX7zkv9///cSWW4oxEQy3mouJEAC7SyM5wAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 00:04, Mimi Zohar wrote:
> On Wed, 2014-04-23 at 16:30 +0300, Dmitry Kasatkin wrote: 
>> This patch provides convenient buffer hash calculation function.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Where/how is it being used?  We normally don't upstream a new function
> without it being used.  Is the usage in another patch?
>
> Mimi

Sure.. it is used in PATCH 15.

>> ---
>>  security/integrity/ima/ima.h        |  1 +
>>  security/integrity/ima/ima_crypto.c | 11 +++++++++--
>>  2 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
>> index f4c1e8dd..a5d5ccb 100644
>> --- a/security/integrity/ima/ima.h
>> +++ b/security/integrity/ima/ima.h
>> @@ -98,6 +98,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>>  			   const char *op, struct inode *inode,
>>  			   const unsigned char *filename);
>>  int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
>> +int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash);
>>  int ima_calc_field_array_hash(struct ima_field_data *field_data,
>>  			      struct ima_template_desc *desc, int num_fields,
>>  			      struct ima_digest_data *hash);
>> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
>> index 139e7f7..50c78c0 100644
>> --- a/security/integrity/ima/ima_crypto.c
>> +++ b/security/integrity/ima/ima_crypto.c
>> @@ -434,13 +434,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
>>  		u8 *data_to_hash = field_data[i].data;
>>  		u32 datalen = field_data[i].len;
>>
>> -		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
>> +		if (td && strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
>>  			rc = crypto_shash_update(&desc.shash,
>>  						(const u8 *) &field_data[i].len,
>>  						sizeof(field_data[i].len));
>>  			if (rc)
>>  				break;
>> -		} else if (strcmp(td->fields[i]->field_id, "n") == 0) {
>> +		} else if (td && strcmp(td->fields[i]->field_id, "n") == 0) {
>>  			memcpy(buffer, data_to_hash, datalen);
>>  			data_to_hash = buffer;
>>  			datalen = IMA_EVENT_NAME_LEN_MAX + 1;
>> @@ -475,6 +475,13 @@ int ima_calc_field_array_hash(struct ima_field_data *field_data,
>>  	return rc;
>>  }
>>
>> +int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash)
>> +{
>> +	struct ima_field_data fd = { .data = (u8 *)buf, .len = len };
>> +
>> +	return ima_calc_field_array_hash(&fd, NULL, 1, hash);
>> +}
>> +
>>  static void __init ima_pcrread(int idx, u8 *pcr)
>>  {
>>  	if (!ima_used_chip)
>
>

