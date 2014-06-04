Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaFDLVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:21:14 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:54981 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaFDLVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:21:13 -0400
Message-ID: <538F0127.9040300@acm.org>
Date: Wed, 04 Jun 2014 13:21:11 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
CC: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
Subject: Re: [PATCH v2 0/6] virtio-scsi patches for 3.16 + midlayer fix
References: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1401876703-10236-1-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/14 12:11, Paolo Bonzini wrote:
> v1->v2: fix all occurrences of "scmd->result |= DID_TIME_OUT << 16"
>         in patch 4

Hello Paolo,

Thanks for the quick respin. However, since you are mentioning that in
v2 all occurrences of "scmd->result |= DID_TIME_OUT << 16" have been
addressed, this made me wonder whether you had noticed the following
code in scsi_decide_disposition() ?

	switch (host_byte(scmd->result)) {
	[ ... ]
	case DID_ABORT:
		if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
			scmd->result |= DID_TIME_OUT << 16;
			return SUCCESS;
		}

Thanks,

Bart.

