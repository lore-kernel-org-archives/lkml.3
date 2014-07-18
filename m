Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbaGRDlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:41:44 -0400
Received: from tundra.namei.org ([65.99.196.166]:33990 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbaGRDll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:41:41 -0400
Date: Fri, 18 Jul 2014 13:41:07 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] firmware_class: perform new LSM checks
In-Reply-To: <1405373897-31671-5-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.11.1407181339510.15709@namei.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org> <1405373897-31671-5-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Kees Cook wrote:

> This attaches LSM hooks to the existing firmware loading interfaces:
> filesystem-found firmware and demand-loaded blobs.

>  static int fw_get_filesystem_firmware(struct device *device,
> @@ -640,6 +646,12 @@ static ssize_t firmware_loading_store(struct device *dev,
>  		break;
>  	case 0:
>  		if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
> +			if (security_kernel_fw_from_file(NULL, fw_buf->data,
> +							 fw_buf->size)) {
> +				fw_load_abort(fw_priv);
> +				break;
> +			}
> +
>  			set_bit(FW_STATUS_DONE, &fw_buf->status);
>  			clear_bit(FW_STATUS_LOADING, &fw_buf->status);
>  
> 

Can you explain the loading store, and what the semantics are for an LSM 
when a NULL is passed as the file?


-- 
James Morris
<jmorris@namei.org>

