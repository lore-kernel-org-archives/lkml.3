Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbbATNGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:06:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbbATNGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:06:33 -0500
Date: Tue, 20 Jan 2015 14:06:09 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jeremie.galarneau@efficios.com, bigeasy@linutronix.de, lizefan@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: convert: fix duplicate field names.
Message-ID: <20150120130609.GC15315@krava.brq.redhat.com>
References: <1421752029-64237-1-git-send-email-wangnan0@huawei.com>
 <1421752029-64237-2-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421752029-64237-2-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 07:07:08PM +0800, Wang Nan wrote:

SNIP

> +		 *
> +		 * So instead of checking duplication, simply tries 10 times.
> +		 */
> +		for (dup = 0; dup < 10; dup ++) {
> +			struct bt_ctf_field_type *f;
> +			char *dupl_name = get_dupl_name(field->name, dup);
> +
> +			if (!dupl_name) {
> +				pr_err("Failed to alloc memory for dup '%s'\n",
> +						field->name);
> +				return -1;
> +			}
> +
> +			ret = bt_ctf_event_class_add_field(event_class, type,
> +					dupl_name);
> +			free(dupl_name);
> +			if (ret)
> +				continue;

hum.. so we dont know if we failed because of the name, but we keep
trying 10 times anyway.. does not seem nice to me

how about using that function you mentioned in the above comment
to get the proper name first, like:

   while(bt_ctf_event_class_get_field_by_name(name))
       change_name(name)

and then add use it for bt_ctf_event_class_add_field

thanks,
jirka
