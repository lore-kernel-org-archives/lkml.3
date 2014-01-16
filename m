Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaAPJmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:42:08 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:39149 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaAPJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:42:04 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssVY9SQsClBrtp5eFYXU7YfNKMAfocpEeot7SjdQ==
X-RZG-CLASS-ID: mo00
Date: Thu, 16 Jan 2014 10:42:01 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140116094200.GA16328@aepfle.de>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1389728116-21337-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, K. Y. Srinivasan wrote:

> +enum hv_fcopy_op {
> +	START_FILE_COPY = 0,
> +	WRITE_TO_FILE,
> +	COMPLETE_FCOPY,
> +	CANCEL_FCOPY,
> +};
> +
> +struct hv_fcopy_hdr {
> +	enum hv_fcopy_op operation;
> +	uuid_le service_id0; /* currently unused */
> +	uuid_le service_id1; /* currently unused */
> +} __attribute__((packed));

Is enum a fixed size? This struct is used in other structs, so I wonder
what will happen to the kernel/user protocol if any of that changes. Or
with a 64bit kernel and 32bit daemon. Maybe operation should be __u32?


Olaf
