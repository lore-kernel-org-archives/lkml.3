Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaDNXvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:51:10 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:62140 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaDNXvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:51:07 -0400
Date: Mon, 14 Apr 2014 17:51:03 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Ryan Desfosses <ryan@desfo.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] access: moved trailing statements and added spaces after
 ','
Message-ID: <20140414235103.GC16058@google.com>
References: <1397289387-4440-1-git-send-email-ryan@desfo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397289387-4440-1-git-send-email-ryan@desfo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 03:56:27AM -0400, Ryan Desfosses wrote:
> changes made to resolve following checkpatch messages:
>   ERROR: space required after that ',' (ctx:VxV)
>   ERROR: trailing statements should be on next line
> branch: 3.14
> 
> Signed-off-by: Ryan Desfosses <ryan@desfo.org>

Applied to pci/misc, thanks!

> ---
>  drivers/pci/access.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/access.c b/drivers/pci/access.c
> index 7f8b78c..5d8d0b4 100644
> --- a/drivers/pci/access.c
> +++ b/drivers/pci/access.c
> @@ -25,14 +25,15 @@ DEFINE_RAW_SPINLOCK(pci_lock);
>  #define PCI_word_BAD (pos & 1)
>  #define PCI_dword_BAD (pos & 3)
>  
> -#define PCI_OP_READ(size,type,len) \
> +#define PCI_OP_READ(size, type, len) \
>  int pci_bus_read_config_##size \
>  	(struct pci_bus *bus, unsigned int devfn, int pos, type *value)	\
>  {									\
>  	int res;							\
>  	unsigned long flags;						\
>  	u32 data = 0;							\
> -	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
> +	if (PCI_##size##_BAD)						\
> +	return PCIBIOS_BAD_REGISTER_NUMBER;				\
>  	raw_spin_lock_irqsave(&pci_lock, flags);			\
>  	res = bus->ops->read(bus, devfn, pos, len, &data);		\
>  	*value = (type)data;						\
> @@ -40,16 +41,17 @@ int pci_bus_read_config_##size \
>  	return res;							\
>  }
>  
> -#define PCI_OP_WRITE(size,type,len) \
> +#define PCI_OP_WRITE(size, type, len)		\
>  int pci_bus_write_config_##size \
>  	(struct pci_bus *bus, unsigned int devfn, int pos, type value)	\
>  {									\
>  	int res;							\
>  	unsigned long flags;						\
> -	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
> +	if (PCI_##size##_BAD)						\
> +	return PCIBIOS_BAD_REGISTER_NUMBER;				\
>  	raw_spin_lock_irqsave(&pci_lock, flags);			\
>  	res = bus->ops->write(bus, devfn, pos, len, value);		\
> -	raw_spin_unlock_irqrestore(&pci_lock, flags);		\
> +	raw_spin_unlock_irqrestore(&pci_lock, flags);			\
>  	return res;							\
>  }
>  
> @@ -144,7 +146,7 @@ static noinline void pci_wait_cfg(struct pci_dev *dev)
>  }
>  
>  /* Returns 0 on success, negative values indicate error. */
> -#define PCI_USER_READ_CONFIG(size,type)					\
> +#define PCI_USER_READ_CONFIG(size, type)				\
>  int pci_user_read_config_##size						\
>  	(struct pci_dev *dev, int pos, type *val)			\
>  {									\
> @@ -152,7 +154,7 @@ int pci_user_read_config_##size						\
>  	u32 data = -1;							\
>  	if (PCI_##size##_BAD)						\
>  		return -EINVAL;						\
> -	raw_spin_lock_irq(&pci_lock);				\
> +	raw_spin_lock_irq(&pci_lock);					\
>  	if (unlikely(dev->block_cfg_access))				\
>  		pci_wait_cfg(dev);					\
>  	ret = dev->bus->ops->read(dev->bus, dev->devfn,			\
> @@ -166,7 +168,7 @@ int pci_user_read_config_##size						\
>  EXPORT_SYMBOL_GPL(pci_user_read_config_##size);
>  
>  /* Returns 0 on success, negative values indicate error. */
> -#define PCI_USER_WRITE_CONFIG(size,type)				\
> +#define PCI_USER_WRITE_CONFIG(size, type)				\
>  int pci_user_write_config_##size					\
>  	(struct pci_dev *dev, int pos, type val)			\
>  {									\
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
